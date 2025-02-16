param (
    [string]$namespace = "test-namespace",
    [string]$deployment = "test-app",
    [string]$newCpuRequest = "0.125",
    [string]$newMemoryRequest = "128Mi",
    [string]$newCpuLimit = "0.25",
    [string]$newMemoryLimit = "0.25Gi"
)

Write-Host "Updating resource requests and limits for deployment: $deployment"

$patchJson = @{
    spec = @{
        template = @{
            spec = @{
                containers = @(@{
                    name = "test-app"
                    resources = @{
                        requests = @{
                            cpu = $newCpuRequest
                            memory = $newMemoryRequest
                        }
                        limits = @{
                            cpu = $newCpuLimit
                            memory = $newMemoryLimit
                        }
                    }
                })
            }
        }
    }
} | ConvertTo-Json -Depth 10

kubectl patch deployment $deployment -n $namespace --type='merge' -p $patchJson

Write-Host "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - Resource update applied: CPU 0.125 and 0.25, Memory 128Mi and 0.25Gi"

