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

### ArgoCDはセルフマネージドやめた
なんか唐突に自分自身消し始めるちょっと怖い事案が発生したのでセルフマネージドなArgoCDは取りやめること。原因特定したいのに、目の前で全部消えちゃったので何も残らず……
