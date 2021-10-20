local grafana = import 'grafana/grafana.libsonnet';

{
  prometheus:
    grafana.datasource.new(
      'Prometheus',
      'http://prometheus.default.svc.cluster.local/prometheus',
      'prometheus',
      true,
    ) +
    grafana.datasource.withHttpMethod('POST'),
  tempo:
    grafana.datasource.new(
      'Tempo',
      'http://query-frontend',
      'tempo',
    ),
  sun_and_moon:
    grafana.datasource.new(
      'FOCO',
      null,
      'fetzerch-sunandmoon-datasource',
    ) +
    grafana.datasource.withJsonData({
      latitude: 40.5555,
      longitude: -105.1382,
    }),
}
