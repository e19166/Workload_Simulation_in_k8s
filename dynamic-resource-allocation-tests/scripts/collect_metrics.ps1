# Parameters
$duration = 600  # Duration to run the script in seconds (default: 10 mins)
$interval = 1    # Interval between queries in seconds
$prometheusEndpoint = "http://prometheus-server.default.svc.cluster.local:9090/api/v1/query"
$latencyQuery = "http_server_request_duration_seconds"
$cpuUsageQuery = "container_cpu_usage_seconds_total"
$memoryUsageQuery = "container_memory_usage_bytes"
$timestamp = Get-Date -UFormat "%Y%m%d%H%M%S"
$outputFile = "results/test_results_$timestamp.csv"

# Create the results directory if it doesn't exist
if (!(Test-Path "results")) {
    New-Item -ItemType Directory -Path "results"
}

# Create CSV file and write headers
"timestamp,latency_ms,cpu_usage,memory_usage_bytes" | Out-File -FilePath $outputFile -Encoding utf8

Write-Host "Collecting metrics for $duration seconds..."

# Loop to collect metrics at intervals
for ($i = 0; $i -lt $duration; $i += $interval) {
    $currentTime = Get-Date -UFormat "%s"

    try {
        # URL encode the queries
        $latencyQueryEncoded = [System.Web.HttpUtility]::UrlEncode($latencyQuery)
        $cpuUsageQueryEncoded = [System.Web.HttpUtility]::UrlEncode($cpuUsageQuery)
        $memoryUsageQueryEncoded = [System.Web.HttpUtility]::UrlEncode($memoryUsageQuery)

        # Fetch latency metric
        $latencyResponse = Invoke-RestMethod -Uri "$prometheusEndpoint?query=$latencyQueryEncoded" -Method Get
        $latency = $latencyResponse.data.result[0].value[1] -replace '"', ''

        # Fetch CPU usage metric
        $cpuResponse = Invoke-RestMethod -Uri "$prometheusEndpoint?query=$cpuUsageQueryEncoded" -Method Get
        $cpuUsage = $cpuResponse.data.result[0].value[1] -replace '"', ''

        # Fetch memory usage metric
        $memoryResponse = Invoke-RestMethod -Uri "$prometheusEndpoint?query=$memoryUsageQueryEncoded" -Method Get
        $memoryUsage = $memoryResponse.data.result[0].value[1] -replace '"', ''

        # Append data to CSV
        "$currentTime,$latency,$cpuUsage,$memoryUsage" | Out-File -FilePath $outputFile -Append -Encoding utf8

        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Latency: $latency ms, CPU: $cpuUsage, Memory: $memoryUsage bytes"
    }
    catch {
        Write-Host "Error fetching metrics at $currentTime. Error details: $_"
    }

    # Sleep for the interval duration
    Start-Sleep -Seconds $interval
}

Write-Host "Metrics collection complete. Results saved to: $outputFile"
