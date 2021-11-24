sealed-secrets
===

- repo: https://bitnami-labs.github.io/sealed-secrets
- chart: sealed-secrets
- version: 1.16.1

## Preparation

```bash
# valueファイルを作成
❯ helm show values sealed-secrets/sealed-secrets --version 1.16.1 > manifests/in-cluster/sealed-secrets/values

# Helmのテンプレート作成
❯ helm template sealed-secret sealed-secrets/sealed-secrets --include-crds --output-dir manifests -f manifests/in-cluster/sealed-secrets/values --version 1.16.1 -n sealed-secrets

# 証明書等作成
❯ openssl req -x509 -nodes -newkey rsa:4096  \
  -keyout "manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.key" \
  -out "manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt" \
  -subj "/CN=sealed-secret/O=sealed-secret"

# 名前空間作成
❯ kubectl create namespace "sealed-secrets"

# Secret登録
❯ kubectl -n "sealed-secrets" create secret tls "sealed-secrets-key" \
  --cert="manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt" \
  --key="manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.key"

❯ kubectl -n "sealed-secrets" label secret "sealed-secrets-key" sealedsecrets.bitnami.com/sealed-secrets-key=active
```

## コンテクスト

### 自分の鍵を使って暗号化してる
sealed-secretsはデフォルトの挙動として鍵を自分で生成してSecretとして登録してくれる。これでも良いが、まぁせっかくなので自分で作った鍵で動かそう！ということで自分の鍵を使っている。

そのさい、sealed-secretsが鍵として利用するデフォルトのSecret名が`sealed-secrets-key`なので、自分で作った鍵をこの名前でデプロイしている。これはvaluesの`secretName`で定義されている。

参考: [bring your own certificates](https://github.com/bitnami-labs/sealed-secrets/blob/main/docs/bring-your-own-certificates.md)

### ignoreディレクトリ？なにこれ？
ArgoCDでデプロイする際、秘密鍵のSecretとかを無視してもらうために用意した。この中身のマニフェストは手動でデプロイする。(秘匿情報なので、Gitに登録できない)

詳しくはmanifests/in-cluster/applications/sealed-secrets.yamlを参照して欲しい。命名が非常にあれではあるけど……まぁ許して欲しい

### valuesのcommandArgsってなにものよ？
TL;DR: これ > https://github.com/argoproj/argo-cd/issues/5991

ArgoCDにsealed-secretsを管理させようとすると、永遠にSyncedにならず気持ち悪い状態になってしまう悲しい問題。これはArgoCDはアプリケーションのステータスをstatusフィールドをもって監視するが、sealed-secretsはデフォでstatusフィールドを更新しない挙動をすることが原因

で、Issueの中の話によると、values.yamlのcommandArgsを追加すれば動作するとのこと。理由はよくわかってないが、まぁ動くのならヨシ！

## 使い方

```bash
# 相変わらずルートディレクトリから実行する
❯ kubeseal --cert manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt -f mysecret.yaml -o yaml > sealed-mysecret.yaml
```
