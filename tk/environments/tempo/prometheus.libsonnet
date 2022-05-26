local ksm = import 'github.com/grafana/jsonnet-libs/kube-state-metrics/main.libsonnet';
local prometheus = import 'prometheus/prometheus.libsonnet';
local scrape_configs = import 'prometheus/scrape_configs.libsonnet';

prometheus {
  ksm: ksm.new($._config.namespace),

  prometheus_config+: {
    global+: {
      scrape_interval: '15s',
      external_labels+: {
        cluster: $._config.cluster,
      },
    },

    rule_files: [
      'alerts/alerts.rules',
      'recording/recording.rules',
    ],

    scrape_configs+: [
      scrape_configs.kubernetes_pods,
      scrape_configs.kube_dns,
      ksm.scrape_config($._config.namespace),
    ],
  },
}
