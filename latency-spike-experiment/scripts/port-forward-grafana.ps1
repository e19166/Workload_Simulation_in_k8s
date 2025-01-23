# port-forward-grafana.ps1
# Port-forwards Grafana to access it locally.

Write-Host "Port-forwarding Grafana..."
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
