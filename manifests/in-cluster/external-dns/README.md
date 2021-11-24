ExternalDNS
===

- repo: https://kubernetes-sigs.github.io/external-dns/
- chart: external-dns
- version: v1.6.0

## Preparation

```bash
# values作成
❯ helm show values external-dns/external-dns --version 1.6.0 > manifests/in-cluster/external-dns/values

# テンプレート作成
❯ helm template external-dns external-dns/external-dns --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/external-dns/values --version v1.6.0 -n external-dns

# APIトークン(SealedSecret)作成
❯ kubectl create secret generic cloudflare-api-token --dry-run=client --from-literal=api-token=XXX -n external-dns -o yaml | kubeseal --cert manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt -o yaml > manifests/in-cluster/external-dns/cloudflare-api-token.yaml
```

## コンテクスト

### 依存関係
すべてデプロイするにはSealedSecretとServiceMonitor(Prometheus)のCRDが必要。後者に関してはなくても起動できる。

### bitnami/external-dns使わんの？
これにはSecretでAPIキーを保持する機構がないのでGitOpsには向いてないと判断
