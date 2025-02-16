param (
    [string]$dataFile = "$PSScriptRoot/../results/latency_data_7.csv"
)

Write-Host "Analyzing latency data..."

$latencyData = Import-Csv -Path $dataFile -Header "Timestamp", "LatencyMs"

$avgLatency = ($latencyData | Measure-Object -Property LatencyMs -Average).Average
$maxLatency = ($latencyData | Measure-Object -Property LatencyMs -Maximum).Maximum
$minLatency = ($latencyData | Measure-Object -Property LatencyMs -Minimum).Minimum

Write-Host "Latency Analysis:"
Write-Host "Average Latency: $avgLatency ms"
Write-Host "Max Latency: $maxLatency ms"
Write-Host "Min Latency: $minLatency ms"

Write-Host "Saving analysis results..."
$resultsDir = "$PSScriptRoot/../results"
if (!(Test-Path $resultsDir)) {
    New-Item -ItemType Directory -Path $resultsDir -Force
}

$resultsPath = "$resultsDir/latency_analysis_7.txt"
"$avgLatency,$maxLatency,$minLatency" | Out-File -FilePath $resultsPath

