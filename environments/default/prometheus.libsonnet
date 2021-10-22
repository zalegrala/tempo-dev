local ksm = import 'github.com/grafana/jsonnet-libs/kube-state-metrics/main.libsonnet';
local prometheus = import 'prometheus/prometheus.libsonnet';
local scrape_configs = import 'prometheus/scrape_configs.libsonnet';

local namespace = 'default';
local cluster = 'k3d-tempo';

prometheus {
  _config+:: {
    cluster_name: cluster,
    namespace: namespace,
  },
} +

{
  prometheus_config:: {
    global: {
      scrape_interval: '15s',
    },

    rule_files: [
      'alerts/alerts.rules',
      'recording/recording.rules',
    ],

    scrape_configs: [
      scrape_configs.kubernetes_pods,
      scrape_configs.kube_dns,
    ],
  },
} +

{
  ksm: ksm.new(namespace),

  prometheus_config+: {
    scape_configs+: [
      ksm.scrape_config(namespace),
    ],
  },
}
