# Define variables
$serviceUrl = "http://localhost:8080"  # Replace with your service URL or NodePort
$endpoint = "$serviceUrl/"  # Replace 'your-endpoint' with the actual API path
$deploymentName = "app-deployment"  # Replace with your deployment name
$namespace = "default"  # Replace with your namespace if not default

# CSV file path for logging latency
$csvFile = "latency_data.csv"
if (-Not (Test-Path $csvFile)) {
    "Action,Latency" | Out-File -FilePath $csvFile
} elseif ((Get-Content $csvFile).Trim().Length -eq 0) {
    "Action,Latency" | Out-File -FilePath $csvFile
} elseif (-Not ((Get-Content $csvFile)[0] -like "Action,Latency")) {
    "Action,Latency" | Out-File -FilePath $csvFile -Append
}

# Function to measure latency
function Measure-Latency {
    param (
        [string]$url
    )
    $result = curl $url -w "Total Time: %{time_total}s`n" -o NUL -s
    if ($result -match "Total Time: ([\d\.]+)s") {
        return [double]$matches[1]
    } else {
        Write-Host "Failed to measure latency."
        return $null
    }
}

# Function to get server processing time from logs
function Get-ServerProcessingTimeFromLogs {
    param (
        [string]$logFilePath,
        [string]$requestId
    )
    # Read the log file (assuming logs are in CSV format or another readable format)
    $logEntries = Get-Content $logFilePath | Select-String -Pattern $requestId
    
    # Assuming the server log contains a line like 'ProcessingTime: 0.125'
    foreach ($log in $logEntries) {
        if ($log -match "ProcessingTime: ([\d\.]+)") {
            return [double]$matches[1]
        }
    }

    Write-Host "No processing time found for request ID $requestId"
    return $null
}

# Function to calculate server processing time
function Calculate-ServerProcessingTime {
    param (
        [string]$url,
        [string]$logFilePath,
        [string]$requestId
    )
    # Measure the network + server latency
    $totalTime = Measure-Latency -url $url
    if ($null -eq $totalTime) {
        return $null
    }
    
    # Get the server's own processing time from the logs
    $serverProcessingTime = Get-ServerProcessingTimeFromLogs -logFilePath $logFilePath -requestId $requestId
    if ($null -eq $serverProcessingTime) {
        return $null
    }

    # Assuming that the network latency can be measured separately (like via ping or Measure-Latency)
    # For this example, we're not subtracting network latency explicitly, but it's implied here.
    $networkLatency = 0.1  # Example: you might measure this separately, e.g., using the Measure-Latency function

    # Calculate server-side processing time
    $actualServerProcessingTime = $totalTime - $networkLatency
    return $actualServerProcessingTime
}

# Continuous latency collection
Write-Host "Measuring latency continuously..."

# Measure initial latency
$latencyStart = Measure-Latency -url $endpoint
if ($null -ne $latencyStart) {
    Write-Host "Initial Latency: $latencyStart seconds"
    #"Initial Latency,$latencyStart" | Out-File -FilePath $csvFile -Append
} else {
    Write-Host "Failed to measure initial latency."
}

# Log latency during execution steps (pre-scaling)
Write-Host "Measuring latency before scaling..."
$latencyBefore = Measure-Latency -url $endpoint
if ($null -ne $latencyBefore) {
    Write-Host "Latency before scaling: $latencyBefore seconds"
    "Before Scaling,$latencyBefore" | Out-File -FilePath $csvFile -Append
} else {
    Write-Host "Failed to measure latency before scaling."
}

# Get the container image for scaling
$image = kubectl get deployment $deploymentName -o jsonpath='{.spec.template.spec.containers[0].image}'

# Scaling and measuring latency 5 times (decreasing CPU limits progressively)
$cpuRequests = 100
$cpuLimits = 1000
$memoryRequests = "256Mi"
$memoryLimits = "512Mi"

for ($i = 1; $i -le 100; $i++) {
    # Apply vertical scaling
    Write-Host "Decreasing CPU limits (Step $i)..."
    kubectl patch deployment $deploymentName -n $namespace -p @"
    {
        "spec": {
            "template": {
                "spec": {
                    "containers": [
                        {
                            "name": "app",  
                            "image": "$image",
                            "resources": {
                                "requests": {
                                    "cpu": "${cpuRequests}m",
                                    "memory": "$memoryRequests"
                                },
                                "limits": {
                                    "cpu": "${cpuLimits}m",
                                    "memory": "$memoryLimits"
                                }
                            }
                        }
                    ]
                }
            }
        }
    }
"@

    # Wait for the scaling operation to complete
    Write-Host "Waiting for the scaling operation to complete..."
    Start-Sleep -Seconds 10  # Adjust this based on your scaling time

    # Log latency after scaling
    $latencyAfter = Measure-Latency -url $endpoint
    if ($null -ne $latencyAfter) {
        Write-Host "Latency after step $i $latencyAfter seconds"
        "Degrade Step ${i},$latencyAfter" | Out-File -FilePath $csvFile -Append
    } else {
        Write-Host "Failed to measure latency after step $i."
    }

    # Decrease CPU requests and limits for the next iteration
    #$cpuRequests -= 100
    $cpuLimits -= 5

    # Optionally: Log server processing time from logs (this would require the requestId and log access)
    $requestId = "request-id-$i"  # Example request ID (replace with actual)
    $logFilePath = Join-Path -Path $PSScriptRoot -ChildPath "logs.txt"  # Example path to your log file
    $serverProcessingTime = Calculate-ServerProcessingTime -url $endpoint -logFilePath $logFilePath -requestId $requestId
    if ($null -ne $serverProcessingTime) {
        Write-Host "Server-side Processing Time for step $i $serverProcessingTime seconds"
        "Server Processing Step ${i},$serverProcessingTime" | Out-File -FilePath $csvFile -Append
    }
}

# Log continuous latency during the script run (for example, every 10 seconds)
<# Write-Host "Logging continuous latency..."
for ($i = 0; $i -lt 100; $i++) {
    $continuousLatency = Measure-Latency -url $endpoint
    if ($null -ne $continuousLatency) {
        Write-Host "Continuous Latency #$($i+1): $continuousLatency seconds"
        "Continuous Latency #$($i+1),$continuousLatency" | Out-File -FilePath $csvFile -Append
    }
    Start-Sleep -Seconds 0.5  # Adjust this interval to suit your needs
} #>

# Output completion
Write-Host "Latency data collection complete. Data saved to $csvFile."
