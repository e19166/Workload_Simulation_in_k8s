# Scale pod by modifying the deployment resource limits and requests
$deploymentName = "app-deployment"
$namespace = "default"

# Example to scale CPU and Memory limits/requests for vertical scaling
kubectl set resources deployment $deploymentName -n $namespace --limits=cpu=2,memory=2Gi --requests=cpu=1,memory=1Gi
Write-Host "Scaled pod resources to CPU: 2, Memory: 2Gi"
