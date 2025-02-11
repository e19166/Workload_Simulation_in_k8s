# Define variables
$serviceUrl = "http://localhost:30081"  # Replace with your service URL or NodePort
$endpoint = "$serviceUrl/"  
$deploymentName = "app-deployment"  
$namespace = "default"  

# CSV file path for logging latency
$csvFile = "latency_data.csv"
if (-Not (Test-Path $csvFile)) {
    "Action,Latency" | Out-File -FilePath $csvFile 
}

# Function to measure latency
function Measure-Latency {
    param ([string]$url)
    $result = & curl.exe $url -w "Total Time: %{time_total}s`n" -o NUL -s
    if ($result -match "Total Time: ([\d\.]+)s") {
        return [double]$matches[1]
    } else {
        Write-Host "Failed to measure latency."
        return $null
    }
}

# Function to check pod health
function Check-PodStatus {
    param ([string]$deployment, [string]$namespace)
    $podStatus = kubectl get pods -n $namespace -l app=$deployment --no-headers
    if ($podStatus -match "Pending|Error|Terminating") {
        return $false
    }
    return $true
}

# Get the container image
$image = kubectl get deployment $deploymentName -o jsonpath='{.spec.template.spec.containers[0].image}'

# Initial resource values
$cpuLimits = 1000
$memoryLimits = 800
$throttleDetected = $false
$failureDetected = $false

# Measure initial latency
$latencyStart = Measure-Latency -url $endpoint
Write-Host "Initial Latency: $latencyStart seconds"
"Initial Latency,$latencyStart" | Out-File -FilePath $csvFile -Append

# Reduction loop
for ($i = 1; $i -le 20; $i++) {
    # Reduce CPU & Memory Limits
    $cpuLimits -= 50
    #$memoryLimits -= 5
    Write-Host "Reducing resources: CPU=${cpuLimits}m, Memory=${memoryLimits}Mi"
    $image = kubectl get deployment $deploymentName -o jsonpath='{.spec.template.spec.containers[0].image}'
    # Apply new resource limits
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

    # Wait for changes to take effect
    Start-Sleep -Seconds 10  

    <# # Check pod status
    if (-not (Check-PodStatus -deployment $deploymentName -namespace $namespace)) {
        Write-Host "Pod failure detected! Stopping tests."
        $failureDetected = $true
        break
    } #>

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
    # Measure latency
    $latencyAfter = $latencySum / 10
    if ($null -ne $latencyAfter) {
        Write-Host "Step $i Latency $latencyAfter seconds"
        "Step ${i},$latencyAfter" | Out-File -FilePath $csvFile -Append
    } else {
        Write-Host "Failed to measure latency at step $i."
    }

    # Check for CPU throttling (optional)
    $throttleData = kubectl top pod -n $namespace | Select-String -Pattern "app"
    if ($throttleData -match "([0-9]+)m") {
        $cpuUsage = [int]$matches[1]
        if ($cpuUsage -ge $cpuLimits) {
            Write-Host "CPU Throttling detected! Stopping tests."
            $throttleDetected = $true
            break
        }
    }
}

# Summary
if ($failureDetected) {
    Write-Host "Test stopped due to pod failure!"
} elseif ($throttleDetected) {
    Write-Host "Test stopped due to CPU throttling!"
} else {
    Write-Host "Test completed without reaching failure!"
}

Write-Host "Latency data collection complete. Data saved to $csvFile."
