Grafana
===

- repo: https://grafana.github.io/helm-charts
- chart: grafana
- version: 6.19.1

## Preparation

```bash
# values作成
❯ helm show values grafana/grafana --version 6.19.1> manifests/in-cluster/grafana/values

# テンプレート作成
❯ helm template grafana grafana/grafana --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/grafana/values --version 6.19.1 -n grafana 
```

## コンテクスト

### 依存関係
すべてデプロイするにはCertificate(cert-manager)とServiceMonitor(Prometheus)のCRDが必要。Prometheusはなくても動くが、ダッシュボードとして動かないのでPrometheusも起動済みであることが望ましい。

### Operatorは使わんの？
使えばよかったなとデプロイが一通り終わった今更思ってる。頼んだ、未来の僕
