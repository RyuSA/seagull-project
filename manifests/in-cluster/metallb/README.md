MetalLB
===

- repo: https://metallb.github.io/metallb
- chart: metallb
- version: 0.11.0

## Preparation

```bash
# valueファイルを作成
❯ helm show values metallb/metallb --version 0.11.0 > manifests/in-cluster/metallb/values

# テンプレート作成
❯ helm template metallb metallb/metallb --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/metallb/values --version 0.11.0 -n metallb
```

## コンテクスト

### ネットワーク設定
自宅のネットワークのうち`192.168.168.0/24`をKubernetesのLoadBalancer用に予約済みのため、valuesにその設定が反映されています。

```yaml
configInline:
  address-pools:
  - name: default
    protocol: layer2
    addresses:
    - 192.168.168.0/24
```
