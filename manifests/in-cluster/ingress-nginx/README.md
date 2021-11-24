ingress-nginx
===

- repo: https://kubernetes.github.io/ingress-nginx
- chart: ingress-nginx
- version: 4.0.6

## Preparation

```bash
# valueファイルを作成
❯ helm show values ingress-nginx/ingress-nginx --version 4.0.6 > manifests/in-cluster/ingress-nginx/values

# テンプレート作成
❯ helm template ingress-nginx ingress-nginx/ingress-nginx --include-crds --output-dir manifests/in-cluster -f manifests/in-cluster/ingress-nginx/values --version 4.0.6 -n ingress-nginx
```

## コンテクスト

### 依存関係
正常に動作させるにはMetalLBが必要。ない場合type: LoadBalancerなServiceが作成できないためIngressのプロビジョニングがうまくいかなくなる。

### Operator使わんの？
まだいらないかな……必要になったら入れ替えておいて、未来のぼく

### nginx-stableのNGINX Controller使わんの？
あっちは安定機能しかなくて今回欲しい機能が無い

- SSLパススルー: vclusterのエンドポイント用

nginx-stableはそもそもnginx-plus用っぽい感じがする……もし↑の機能がstableにも入ったら移行を少し考えてみよう。
