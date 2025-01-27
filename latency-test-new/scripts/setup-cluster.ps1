# Check if Docker Desktop is running
$dockerStatus = docker info | Select-String "Server Version"
if (-not $dockerStatus) {
    Write-Host "Docker Desktop is not running, starting Docker..."
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Start-Sleep -Seconds 10
}

# Enable Kubernetes in Docker Desktop if not enabled
$kubectlStatus = kubectl version --client
if (-not $kubectlStatus) {
    Write-Host "Enabling Kubernetes in Docker Desktop..."
    & 'C:\Program Files\Docker\Docker\Docker Desktop.exe' --enable-kubernetes
    Start-Sleep -Seconds 10
}

# Wait until Kubernetes is ready
while (!(kubectl cluster-info)) {
    Write-Host "Waiting for Kubernetes to be ready..."
    Start-Sleep -Seconds 5
}
Write-Host "Kubernetes cluster is ready!"
