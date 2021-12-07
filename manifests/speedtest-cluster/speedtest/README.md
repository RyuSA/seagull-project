speedtest
===

- 生マニフェスト管理
- かつ、PushgatewayをHelmで管理

## Preparation

```bash
# valueファイルを作成
❯ helm show values prometheus-community/prometheus-pushgateway --version 1.13.0 > manifests/speedtest-cluster/speedtest/values

# テンプレート作成
❯ helm template speedtest prometheus-community/prometheus-pushgateway --include-crds --output-dir manifests/speedtest-cluster -f manifests/speedtest-cluster/speedtest/values --version 1.13.0 --namespace speedtest 
```

## コンテクスト

### 依存関係
PrometheusのCRDであるServiceMonitorが必要です。

### どうゆう仕組み？
仮想KubernetesにPushGatewayとCronJobをデプロイし、Podがホスト側に同期されてスピードテストが実行されます。スピードテストの結果はPushgatewayに同期されるようになってます。
その一方でホスト側にデプロイしたServiceMonitorの設定に従い、ホスト側のPrometheusがPushgatewayを舐めてスピードテストの結果がホスト側のPrometheusに反映されるようになってます。

### なんでこんなことしてんの？
正直ここまでやる必要はないと思ったが、開発途中のものをホストに入れるのはちょっと怖かったんで……

### ServiceMonitor、なんかセレクターがキモくない……？
vcluster上のリソースをホストに同期する際にラベルをドロップしてしまいます。なのでホスト側からスクレイピングするラベルはちょっときもい設定になってます。

https://github.com/loft-sh/vcluster/issues/27

が、いつかドロップしないようになるとIssueにもあるので今後に期待。
