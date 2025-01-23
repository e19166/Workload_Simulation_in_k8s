# apply-manifests.ps1
# Applies all the Kubernetes manifests to set up the experiment.

Write-Host "Applying Kubernetes manifests..."
kubectl apply -f ..\manifests\namespace.yaml
kubectl apply -f ..\manifests\prometheus-rule.yaml
kubectl apply -f ..\manifests\nginx-deployment.yaml
kubectl apply -f ..\manifests\vertical-scaling-job.yaml
Write-Host "Manifests applied successfully."
