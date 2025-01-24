# port-forward-grafana.ps1
# Port-forwards Grafana to access it locally.

Write-Host "Port-forwarding Grafana..."
kubectl port-forward svc/kube-prometheus-stack-grafana -n prometheus 3000:80
