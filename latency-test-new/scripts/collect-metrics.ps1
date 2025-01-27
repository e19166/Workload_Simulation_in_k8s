# Define variables
$serviceUrl = "http://localhost:8083"  
$endpoint = "$serviceUrl/"  
$deploymentName = "app-deployment"  
$namespace = "default"  

# CSV file path for logging latency
$csvFile = "latency_data.csv"
if (-Not (Test-Path $csvFile)) {
    "Action,Latency" | Out-File -FilePath $csvFile 
} else {# Check if the file is empty or doesn't have a header row
    $content = Get-Content $csvFile -Encoding UTF8
    if ($content.Length -eq 0) {
        "Action,Latency" | Out-File -FilePath $csvFile -Encoding UTF8
    } elseif ($content[0] -notlike "Action,Latency") {
        "Action,Latency" | Out-File -FilePath $csvFile -Append -Encoding UTF8
} 
}

# Function to measure latency
function Measure-Latency {
    param (
        [string]$url
    )
    $result = & curl.exe $url -w "Total Time: %{time_total}s`n" -o NUL -s
    if ($result -match "Total Time: ([\d\.]+)s") {
        return [double]$matches[1]
    } else {
        Write-Host "Failed to measure latency."
        return $null
    }
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
$memoryRequests = 256
$memoryLimits = 600

for ($i = 1; $i -le 10; $i++) {
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
                                    "memory": "${memoryRequests}Mi"
                                },
                                "limits": {
                                    "cpu": "${cpuLimits}m",
                                    "memory": "${memoryLimits}Mi"
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
    Start-Sleep -Seconds 10  

    # Log latency after scaling
    $latencySum = 0
    for ($j = 0; $j -lt 10; $j++){
        $temp = Measure-Latency -url $endpoint
        if ($null -ne $temp) {
            $latencySum += $temp
        } else {
            Write-Host "Failed to measure latency on iteration $j."
        }
    }
    $latencyAfter = $latencySum / 10
    if ($null -ne $latencyAfter) {
        Write-Host "Latency after step $i $latencyAfter seconds"
        "Degrade Step ${i},$latencyAfter" | Out-File -FilePath $csvFile -Append
    } else {
        Write-Host "Failed to measure latency after step $i."
    }

    # Decrease CPU requests and limits for the next iteration
    #$cpuRequests += 50
    #$cpuLimits -= 50
    #$memoryRequests += 20
    $memoryLimits -= 20

    
}

# Log continuous latency during the script run (for example, every 10 seconds)
<# Write-Host "Logging continuous latency..."
for ($i = 0; $i -lt 100; $i++) {
    $continuousLatency = Measure-Latency -url $endpoint
    if ($null -ne $continuousLatency) {
        Write-Host "Continuous Latency #$($i+1): $continuousLatency seconds"
        "Continuous Latency #$($i+1),$continuousLatency" | Out-File -FilePath $csvFile -Append
    }
    Start-Sleep -Seconds 0.5  
} #>

# Output completion
Write-Host "Latency data collection complete. Data saved to $csvFile."
