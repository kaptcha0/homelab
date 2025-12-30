# initial setup

## infrastructure stuff
First, provision the VMs

```sh
nix run .#apply
```

Then, copy over the kubeconfig from the root k3s server

```sh
scp root@10.67.0.10:/etc/rancher/k3s/k3s.yaml ~/.kube/config
```

Edit the kubeconfig to point to the root k3s server.

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: SOME_STRING
    server: https://10.67.0.10:6443 # change to this from 127.0.0.1
# ...
```


## k8s setup

### calico

Set up calico

```sh
kubectl apply -k ./k8s/infrastructure/calico/
```

### flux

Set up the SOPS secret in the cluster

```sh
kubectl create namespace flux-system
cat $AGE_KEY_FILE | kubectl create secret generic sops-age -n flux-system --from-file=age.agekey=/dev/stdin
```

Bootstrap FluxCD

```sh
flux bootstrap github --token-auth --owner=$GITHUB_USER --repository=homelab --branch=main --path=k8s/cluster/homelab --personal
```
