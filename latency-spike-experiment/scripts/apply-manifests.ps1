kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/prometheus-rule.yaml
kubectl apply -f manifests/nginx-deployment.yaml
kubectl apply -f manifests/vertical-scaling-job.yaml
