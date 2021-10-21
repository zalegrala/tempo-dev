local foco = import 'dashboards/foco.json';
local node_exporter = import 'grafana-dashboards/prometheus/node-exporter-full.json';
local tempo_operational = import 'tempo-mixin/yamls/tempo-operational.json';

{
  foco: foco,
  node_exporter: node_exporter,
  tempo_operational: tempo_operational,
}
