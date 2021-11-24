
❯ helm show values loft/vcluster --version 0.4.3 > cluster/test/values           

❯ helm template dev-cluster loft/vcluster --include-crds --output-dir cluster -f cluster/development/values --version 0.4.3 --namespace dev-cluster

