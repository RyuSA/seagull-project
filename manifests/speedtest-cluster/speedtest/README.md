
❯ helm show values prometheus-community/prometheus-pushgateway --version 1.13.0 > manifests/speedtest/values

❯ helm template speedtest prometheus-community/prometheus-pushgateway --include-crds --output-dir manifests -f manifests/speedtest/values --version 1.13.0 --namespace speedtest 

