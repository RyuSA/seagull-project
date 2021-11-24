Prometheus
===

- 生マニフェスト管理

Kubernetes内のメトリクスを収集するために用意

## コンテクスト

### 依存関係
PrometheusのCRDであるPrometheusが必要です。

### 外部ストレージ使わないの？
そこまでサイズ大きくないし……まだいいかな？後日、もしシステム用のPrometheusとその他のPrometheusで分けて管理したくなったら、VictoriaMetricsとか使っていい感じにやろうと思う
