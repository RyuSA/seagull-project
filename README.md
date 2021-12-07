Project seagull
===

Project seagullはRyuSAのおうちKubernetesを支えるGitOpsリポジトリです。このリポジトリを起点にArgoCDがクラスターにアプリケーションやミドルウェア、また仮想Kubernetesをデプロイしていきます。

## 全体像

```bash
.
├── cluster # Kubernetesディレクトリ
│   ├── in-cluster # Bootstrap
│   └── ...
│
├── manifests # 全マニフェストディレクトリ
│   └── in-cluster # クラスターごとのマニフェストディレクトリ
│       ├── applications # Bootstrap
│       │   ├── application.yaml
│       │   └── ...
│       ├── argocd
│       │   ├── crds
│       │   └── templates
│       └── ...
│
└── servers # 各サーバーの初期設定スクリプトなど
    └── ...
```

### clusters
`clusters`配下にはin-clusterクラスターの上で動く仮想Kubernetesの構成情報をGitOpsできるようなマニフェストがセットアップされています。

```bash
.
├── cluster # Kubernetesディレクトリ
│   ├── root
│   │   ├── root.yaml # Bootstrap
│   │   └── dev-cluster.yaml
│   ├── dev-cluster
│   │   ├── namespace.yaml
│   │   ├── kubeconfig.yaml
│   │   └── templates
```

App of Apps Patternで実装してあり、Bootstrap用の`cluster/root/root.yaml`をArgoCDに喰わせることで各仮想Kubernetesが次々とデプロイされていきます。

接続のための設定は`cluster/$CLUSTER_NAME/sealed-cluster.yaml`に記述されており、このファイルはrootクラスターにデプロイされているSealedSecretによって暗号化されている状態になってます。

詳細 > [仮想Kubernetes管理](./cluster/READMD.md)

### manifests
`manifests`配下にKubernetesへデプロイするアプリケーション/ミドルウェアの構成情報をGitOpsできるようなマニフェストがセットアップされています。

```bash
.
├── manifests
│   ├── dev-cluster
│   │   ├── applications
│   │   │   ├── application.yaml # Bootstrap for dev-cluster
│   │   │   └── speedtest.yaml
│   │   ├── speedtest
│   │   │   ├── templates
│   │   │   └── values
│   │   └── ...
│   │
│   └── in-cluster
│       ├── applications
│       │   ├── application.yaml # Bootstrap for in-cluster
│       │   ├── argocd.yaml
│       │   └── ...
│       ├── argocd
│       │   ├── crds
│       │   ├── templates
│       │   └── values
│       │
│       └── ...
```

App of Apps Patternで実装してあり、Bootstrap用の`manifests/$CLUSTER_NAME/applications/application.yaml`をArgoCDに喰わせることで各Kubernetes上にアプリケーションが次々とデプロイされていきます。

詳細 > [マニフェスト管理](./manifests/README.md)

## 初期構築

```bash
#############################################
### ArgoCDをデプロイ
#############################################
❯ kubectl apply -f manifests/in-cluster/argocd/namespace.yaml
❯ kubectl apply -f manifests/in-cluster/argocd/crds -f manifests/in-cluster/argocd/templates --recursive -n argocd

#############################################
### SealedSecretが要求するSecretを作成
#############################################

# 名前空間作成
❯ kubectl create namespace "sealed-secrets"

# Secret登録
❯ kubectl -n "sealed-secrets" create secret tls "sealed-secrets-key" --cert="manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.crt" --key="manifests/in-cluster/sealed-secrets/ignore/sealed-secrets.key"
❯ kubectl -n "sealed-secrets" label secret "sealed-secrets-key" sealedsecrets.bitnami.com/sealed-secrets-key=active

#############################################
### Bootstrap Application
#############################################
❯ kubectl apply -f manifests/in-cluster/applications/application.yaml

#############################################
### Bootstrap Cluster
#############################################
❯ kubectl apply -f cluster/root/root.yaml
```
