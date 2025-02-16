param (
    [string]$DeploymentName = "test-app-0",
    [string]$Namespace = "default",
    [string]$CPURequest = "100m",
    [string]$MemoryRequest = "128Mi"
)

Write-Host "Updating resource allocation for $DeploymentName..."

kubectl set resources deployment $DeploymentName -n $Namespace --requests=cpu=$CPURequest,memory=$MemoryRequest

Write-Host "Resource update applied successfully!"
