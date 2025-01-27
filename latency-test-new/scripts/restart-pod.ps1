# Get the pod name
$podName = kubectl get pods -l app=app-deployment -o jsonpath='{.items[0].metadata.name}'

# Restart the pod
kubectl delete pod $podName
Write-Host "Pod $podName restarted."
