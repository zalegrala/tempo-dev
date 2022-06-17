local grafana = import 'grafana/grafana.libsonnet';
local mixins = import 'mixins.libsonnet';

{
  _images+:: {
    grafana: 'grafana/grafana:8.5.3',
  },

  grafana:
    grafana
    + grafana.withAnonymous()
    + grafana.withTheme('dark')
    + grafana.withRootUrl('http://grafana')
    + grafana.withImage($._images.grafana)

    + grafana.withGrafanaIniConfig({
      sections+: {
        feature_toggles: {
          enable: 'tempoSearch,tempoServiceGraph',
        },
      },
    })

    + grafana.addDatasource(
      'prometheus',
      grafana.datasource.new(
        'Prometheus',
        'http://prometheus/prometheus',
        'prometheus',
        default=true
      )
      + { uid: 'prometheus' },
    )

    + grafana.addDatasource(
      'tempo',
      grafana.datasource.new(
        'Tempo',
        'http://query-frontend:3200',
        'tempo',
      )
      + { uid: 'tempo' },
    )

    + grafana.addDatasource(
      'loki',
      grafana.datasource.new(
        'Loki',
        'http://read',
        'loki'
      )
      + grafana.datasource.withJsonData({
        derivedFields: [
          {
            datasourceUid: 'Tempo',
            matcherRegex: '(?:traceID|traceid)=(\\w+)',
            name: 'TraceID',
            url: '$${__value.raw}',
          },
        ],
      })
      + { uid: 'loki' },
    )

    + grafana.addMixinDashboards(mixins),
}
