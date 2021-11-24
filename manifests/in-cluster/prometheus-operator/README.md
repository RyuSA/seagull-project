prometheus-exporter
===

- 公式マニフェスト管理
- version: v.0.52.0

## Preparation

```bash
# bundleを持ってくる
❯ curl https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.52.0/bundle.yaml -Lo manifests/prometheus-operator/bundle.yaml

# 名前空間をprometheus-operatorに変更
❯ sed -i -e 's/namespace: default/namespace: prometheus-operator/g' manifests/prometheus-operator/bundle.yaml 
```

## コンテクスト
NONE
