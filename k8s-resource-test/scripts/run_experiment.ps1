param (
    [string]$duration = "120",
    [string]$namespace = "test-namespace",
    [string]$deploymentName = "test-app",
    [string]$localPort = "8084",
    [string]$containerPort = "80"
)

# Set base path for absolute paths
$basePath = "D:\Research\MiccroServices\java-order-service\java-order-service\k8s-resource-test\scripts"

# Deploy the application
Write-Host "🚀 Deploying the application..."
& "$basePath\deploy_app.ps1"

# Start port forwarding in the foreground and wait for it to be ready
Write-Host "🔗 Setting up port forwarding..."
Start-Process -NoNewWindow -FilePath "kubectl" -ArgumentList "port-forward -n $namespace svc/$deploymentName $localPort`:$containerPort"

# Wait until the port is available
Write-Host "⏳ Waiting for port to be available..."
do {
    Start-Sleep -Seconds 2
    $portCheck = Test-NetConnection -ComputerName "localhost" -Port $localPort
} while (-not $portCheck.TcpTestSucceeded)
Write-Host "✅ Port forwarding is active on localhost:$localPort"

# Collect initial latency metrics
Write-Host "📊 Collecting initial latency metrics..."
& "$basePath\collect_metrics.ps1" -duration $duration

# Adjust resource allocations
Write-Host "⚙️ Adjusting resources..."
& "$basePath\adjust_resources.ps1" -newCpuRequest "0.1" -newMemoryRequest "128Mi" -newCpuLimit "0.2" -newMemoryLimit "256Mi"

# Wait for the pod to restart and be ready
Write-Host "⏳ Waiting for the pod to restart..."
do {
    Start-Sleep -Seconds 5
    $podStatus = kubectl get pods -n $namespace -l app=$deploymentName --no-headers | Select-String "Running"
} while (-not $podStatus)
Write-Host "✅ Pod is running. Resuming metrics collection."

# Restart port forwarding after pod restart
Write-Host "🔗 Restarting port forwarding..."
Start-Process -NoNewWindow -FilePath "kubectl" -ArgumentList "port-forward -n $namespace svc/$deploymentName $localPort`:$containerPort"

# Wait until the port is available again
Write-Host "⏳ Waiting for port to be available after restart..."
do {
    Start-Sleep -Seconds 2
    $portCheck = Test-NetConnection -ComputerName "localhost" -Port $localPort
} while (-not $portCheck.TcpTestSucceeded)
Write-Host "✅ Port forwarding is active on localhost:$localPort"

# Collect latency metrics after resource adjustment
Write-Host "📊 Collecting post-adjustment latency metrics..."
& "$basePath\collect_metrics.ps1" -duration $duration

# Analyze results
Write-Host "📈 Analyzing results..."
& "$basePath\analyze_results.ps1"

# Stop port forwarding after the experiment
<# Write-Host "🛑 Stopping port forwarding..."
Stop-Process -Id $portForwardProcess.Id -Force #>

Write-Host "🎯 Experiment completed!"
