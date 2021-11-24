nfs-subdir-external-provisioner
===

- repo: https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
- chart: nfs-subdir-external-provisioner
- version: 4.0.15

## Preparation

```bash
# valueファイルを作成
❯ helm show values nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --version 4.0.14 > manifests/nfs-subdir-external-provisioner/values

# テンプレート作成
❯ helm template nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/nfs-subdir-external-provisioner/values --version 4.0.14 --namespace nfs-subdir-external-provisioner
```

## コンテクスト

### NFSサーバーはどこ？
`nfs.seagull.ryusa.net`にNFSのサーバーとして用意しています。このNFSはKubernetesノード`kingfisher01`の上で実装されています。

### NFSサーバー、Kubernetesの上に立てないの？
立てようかと思ったけど、まぁいつかかな？(面倒になった)
今はm.2 nvmeをマウントしているkingfisher01上に直接NFSサーバーを起動しています。
