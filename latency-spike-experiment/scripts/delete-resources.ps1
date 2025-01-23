# delete-resources.ps1
# Deletes all Kubernetes resources created by the experiment.

Write-Host "Deleting Kubernetes resources..."
kubectl delete namespace latency-test --ignore-not-found
kubectl delete job vertical-scaling-job -n latency-test --ignore-not-found
Write-Host "Resources deleted successfully."
