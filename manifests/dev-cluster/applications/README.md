App of Apps
===

ApplicationでApplicationをデプロイするためのディレクトリ

## インストール方法
```bash
# githubにこのリポジトリをpush

# ArgoCDをデプロイ

# manifests/applications/application.yamlをargocd名前空間にデプロイ
❯ kubectl apply -f manifests/applications/application.yaml -n argocd 

# あとはmanifests/applications/application.yamlに合わせてmanifests/applications/がArgoCDによって読み込まれて
# manifests配下の各アプリケーションが自動デプロイされていく
```
