cert-manager
===

- repo: https://charts.jetstack.io
- chart: cert-manager
- version: v1.6.1

## Preparation

```bash
# valuesファイル作成
❯ helm show values jetstack/cert-manager > manifests/in-cluster/cert-manager/values

# テンプレート作成
❯ helm template cert-manager jetstack/cert-manager --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/cert-manager/values --version v1.6.1 -n cert-manager

# APIトークン(SealedSecret)を作成
❯ kubectl create secret generic cloudflare-api-token --dry-run=client --from-literal=api-token=XXX -n cert-manager -o yaml | kubeseal --cert manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt -o yaml > manifests/in-cluster/cert-manager/cloudflare-api-token.yaml
```

## コンテクスト

### 依存関係
すべてデプロイするにはSealedSecretとServiceMonitor(Prometheus)のCRDが必要。後者に関してはなくても起動できる。前者はないと稼働してくれない(起動はする)

### APIキー vs APIトークン
CloudfrareのDNSを変更するためにはAPIキーかAPIトークンのいずれかを利用することができる。APIトークンはこれ単体で起動することができるものの、APIキーを利用する場合はe-mail情報も必要になる。しかしAPIキーを利用する際のe-mailをClusterIssuerにSecretからアタッチする方法がなく、マニフェストにe-mail直書きが要求されてしまう。

e-mail大公開時代は避けたいので、単体でかつSecretとしてClusterIssuerにアタッチできるAPIトークンを利用することにした。
