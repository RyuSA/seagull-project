ArgoCD
===

- repo: https://argoproj.github.io/argo-helm
- version: 3.26.5

## Preparation

```bash
❯ helm show values argo/argo-cd --version 3.26.5 > manifests/in-cluster/argo-cd/values
❯ helm template argocd argo/argo-cd --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/argo-cd/values --version 3.26.5 -n argocd
```

## Context

### ArgoCDはセルフマネージド
です。一度生のArgoCDをデプロイし、その後Applicationを通じて再デプロイされその後ArgoCDをArgoCD自身で管理していくことになります。
が、さすがに自動同期までしてしまうとちょっと怖いので今回は自動同期はOFFにしてあります。

https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#manage-argo-cd-using-argo-cd
