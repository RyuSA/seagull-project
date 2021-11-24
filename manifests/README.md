マニフェスト管理
===

このディレクトリにはアプリケーションをGitOpsでデプロイするためのマニフェストが保存されています。各アプリケーションのコンテクストや具体的な手順は、アプリケーションのREADMEを参照してください。

## 基本方針
アプリケーションのデプロイは、主に下記の優先順位でGitに登録します。

1. Helmチャート(テンプレート展開)
2. 生マニフェスト(公式/自作)
3. Helmチャート(values.yamlのみ)

なるべく自作するものを最小にしつつ、またデプロイされるリソースの差分が見やすいであろう方式を優先しています。アプリケーションのアップデートの方法はアプリケーションのREADMEを参照してください。

### Helmチャート(テンプレート展開)の基本方針
Helmチャートのvaluesファイルを生成し、適切に修正した後に`helm template`コマンドで展開されたテンプレートが保存されています。

```bash
# 基本構成
.
├── sample-application/
│   ├── crds/
│   ├── templates/
│   ├── namespace.yaml
│   └── values
```

```bash
# valueファイルを作成
❯ helm show values REPO --version VERSION > manifests/CLUSTER_NAME/APP/values

# Helmのテンプレート作成
❯ helm template RELEASE REPO --include-crds --output-dir manifests/CLUSTER_NAME -f manifests/APP/values --version VERSION -n NAMESPACE
```

ArgoCDがテンプレートを読み取れるように`manifests/CLUSTER_NAME/applications/`にApplicationのマニフェストを展開されています。

### マニフェストの基本方針
公式マニフェストをダウンロード、適切に修正されたものが展開されています。また公式マニフェストが存在しない自作ツールなどは手前で実装したマニフェストが配置されています。

```bash
# 基本構成
.
├── sample-application/
│   └── manifest.yaml
```

ArgoCDがテンプレートを読み取れるように`manifests/CLUSTER_NAME/applications/`にApplicationのマニフェストを展開されています。

### Helmチャート(values.yaml)の基本方針
まだない(WIP)

## コンテクスト

### namespaceの切り方は？
基本は「1アプリケーション = 1名前空間」で区切っていく。これは2021年11月現在アルファ版として定義されているPod Security AdmissionによるセキュリティモードのIsorationレベルが名前空間ごとに分離されているため、アプリごとに分離するべきだと判断した。

[Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)

たとえばnode-exporterとsealed-secretが同じ名前空間にいては、Pod Security Admissionをnode-exporterのセキュリティレベルに落とさざるを得なくなりsealed-secretへのセキュリティ強度を落とす必要が出てきてしまう。え？おうちKubernetesにそこまでするかって？気分だよ気分！！

### 仮想KubernetesとルートKubernetesでCRDそのものを共有/同期したいんだけど？
今は、がんばってコピペしかねぇな……(白目) ただvclusterのIssueにプラグイン式でカスタムリソースの同期をしようって話もあがっているので、今後に期待。

https://github.com/loft-sh/vcluster/issues/159
