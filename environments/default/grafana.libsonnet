local dashboards = import 'dashboards.libsonnet';
local datasources = import 'datasources.libsonnet';
local grafana = import 'grafana/grafana.libsonnet';
local mixins = import 'mixins.libsonnet';

grafana
+ grafana.withReplicas(3)
+ grafana.withImage('grafana/grafana:8.2.1')
+ grafana.withRootUrl('http://grafana')
+ grafana.withTheme('dark')
+ grafana.withAnonymous()

// // Plugins
+ grafana.addPlugin('fetzerch-sunandmoon-datasource')

// // Datasources
+ grafana.addDatasource('Prometheus', datasources.prometheus)
+ grafana.addDatasource('FOCO', datasources.sun_and_moon)
+ grafana.addDatasource('tempo', datasources.tempo)

// // Dashboards
+ grafana.addDashboard('node-exporter-full', dashboards.node_exporter, 'Node Exporter')
+ grafana.addDashboard('foco', dashboards.foco, 'Sun and Moon')
+ grafana.addDashboard('tempoOperational', dashboards.tempo_operational, 'Tempo')

// // Mixins
+ grafana.addMixinDashboards(mixins)
