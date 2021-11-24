prometheus-node-exporter
===

- repo: https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
- chart: nfs-subdir-external-provisioner
- version: 4.0.15

## Preparation

```bash
# valueファイルを作成
❯ helm show values prometheus-community/prometheus-node-exporter --version 2.2.0 > manifests/in-cluster/node-exporter/values

# テンプレート作成
❯ helm template node-exporter prometheus-community/prometheus-node-exporter --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/prometheus-node-exporter/values --version 2.2.0 -n prometheus-node-exporter
```

## コンテクスト

### 依存関係
PrometheusのCRDであるServiceMonitorが必要です。

### ServiceMonitorなんで別管理なん？
prometheus-community/prometheus-node-exporterの2.2.0ではServiceMonitorの名前空間がNodeExporterと同一のものになっている。今回は別管理したいので、やむなく別のマニフェストに移設している。

一応Issueはある(というか立てた)ので、後日変わるかもしれないが今は別管理

https://github.com/prometheus-community/helm-charts/issues/1515
