nfs-server
===

- 生マニフェスト

NFSサーバーをKubernetes内部で構築し、Exposeするマニフェストです。NFSは`nfs.seagull.ryusa.net`で露出しています。

## コンテクスト

### コンテナイメージはどうして`itsthenetwork/nfs-server-alpine:12`を？
A. 特に意味はない

とりあえず動きそうだったのでこれにした。実態としては`kingfisher01`上の`/data/exports`を`/exports`にマウントして使っているだけなので、もしもっと良さそうなコンテナイメージがあればそれを使いたい気持ち
