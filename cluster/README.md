仮想Kubernetes管理
===
ArgoCDを通じてvclusterを利用した仮想KubernetesをGitOpsでデプロイします。

## vcluster
Loft Labs社の開発している仮想Kubernetesとしてk3sをデプロイするクラスター

[vcluster](https://www.vcluster.com)

これのHelmチャートを利用していい感じの環境が用意されています。

## 新規クラスター作成
各クラスターはApplicationとして登録されます。そのための準備として

- valuesファイル作成
- valuesファイル修正
- template生成
- Application作成

が必要です。

```bash
# クラスターのvalues.yamlを作成
❯ helm show values loft/vcluster --version 0.4.3 > cluster/development/values 

# vcluster起動時にホストKubernetesのservice-ip-addres-rangeが必要になるため値を取得
# もっとスマートなやり方があれば……
❯ echo '{"apiVersion":"v1","kind":"Service","metadata":{"name":"tst"},"spec":{"clusterIP":"1.1.1.1","ports":[{"port":443}]}}' | kubectl apply -f - 2>&1 | sed 's/.*valid IPs is //' 

# values.yaml修正
# vcluster
#   extraArgs:
#    - --service-cidr=10.96.0.0/16
# ingress:
#   enabled: true
#   host: YOUR_DOMAIN

# その他設定変更があれば

# テンプレート作成
❯ helm template $CLUSTER_NAME loft/vcluster --include-crds --output-dir cluster -f cluster/$CLUSTER_NAME/values --version 0.4.3 --namespace $CLUSTER_NAME

# Namespace作成
# cluster/root配下にApplicationを追加

# kubeconfigを取得する
❯ kubectl exec -it -n $NAMESPACE $CLUSTER_NAME-0 -c syncer -- cat /root/.kube/config > kubeconfig.yaml

# Cluster登録のYAMLを作成
# このSecretをArgoCDが読み取って、自動的にClusterとして組み込んでくれる
# https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#clusters
❯ server=YOUR_DOMAIN
❯ caData=`cat ./kubeconfig.yaml | grep certificate-authority-data | awk '{print $2}'`
❯ certData=`cat ./kubeconfig.yaml | grep client-certificate-data | awk '{print $2}'`
❯ keyData=`cat ./kubeconfig.yaml | grep client-key-data | awk '{print $2}'` 
# YAML作成
❯ cat <<EOF > cluster.yaml
apiVersion: v1
kind: Secret
metadata:
  name: $CLUSTER_NAME-secret
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: $CLUSTER_NAME
  server: $server
  config: |
    {
      "tlsClientConfig": {
        "insecure": false,
        "caData": "$caData",
        "certData": "$certData",
        "keyData": "$keyData"
      }
    }
EOF

# あとはSealedにしてArgoCDに食わせてあげるだけ
❯ kubeseal --cert manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt -f ./cluster.yaml -o yaml > sealed-cluster.yaml
```

## コンテクスト

### 名前空間分離はしないの？
前環境では名前空間分離なクラスターで運用していたものの、開発途中のCRDやCRとかがKubernetesに雑に残ってしまいゴミだらけに……
開発途中のDBは分離するべし、の精神に基づいてKubernetesにおけるスキーマの分離をしようとしたらこうなった。

あとPod Security AdmissionのIsorationのレベルが名前空間だったので、名前空間で区切るのはなんか怪しい空気を感じ取った。(KEP読もうねって話だけど)

### 仮想Kubernetesのエンドポイントってどういう仕組みで動いてる？
rootクラスターのNGINX Ingress Controllerが仮想KubernetesのIngressをプロビジョンしてる。それと設定したhost名はrootクラスターのExternalDNSが適当にDNSに設定してくれるので細かい設定は不要となっている。
