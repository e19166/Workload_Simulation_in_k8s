param (
    [string]$namespace = "test-namespace"
)

# Set base path for absolute paths
$basePath = "D:\Research\MiccroServices\java-order-service\java-order-service\k8s-resource-test"

Write-Host "Creating Kubernetes namespace..."
kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Deploying test application..."
kubectl apply -f "$basePath\manifests\test-app.yaml" -n $namespace

Write-Host "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=test-app -n $namespace --timeout=120s

Write-Host "Application deployed successfully."
