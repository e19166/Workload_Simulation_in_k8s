param (
    [string]$serviceUrl = "http://localhost:8084"
    ,
    [int]$duration = 300
)

Write-Host "Collecting latency data for $duration seconds..."

$latencyData = @()

$startTime = Get-Date
while ((Get-Date) -lt $startTime.AddSeconds($duration)) {
    $responseTime = Measure-Command { Invoke-WebRequest -Uri $serviceUrl -UseBasicParsing } | Select-Object -ExpandProperty TotalMilliseconds
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $latencyData += "$timestamp,$responseTime"
    Start-Sleep -Seconds 1
}

$resultsDir = "D:\Research\MiccroServices\java-order-service\java-order-service\k8s-resource-test\results"
if (!(Test-Path $resultsDir)) {
    New-Item -ItemType Directory -Path $resultsDir -Force
}

$resultsPath = "$resultsDir\latency_data_7.csv"
Write-Host "Writing to: $resultsPath"

$latencyData | Out-File -FilePath $resultsPath -Append

Write-Host "Latency data collected and saved."
