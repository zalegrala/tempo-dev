local dashboards = import 'dashboards.libsonnet';
local datasources = import 'datasources.libsonnet';
local grafana = import 'grafana/grafana.libsonnet';
local mixins = import 'mixins.libsonnet';
local prometheus = import 'prometheus-ksonnet/prometheus-ksonnet.libsonnet';
local tempo = import 'scalable-single-binary/tempo.libsonnet';


grafana
+ grafana.withReplicas(3)
+ grafana.withImage('grafana/grafana:8.2.1')
+ grafana.withRootUrl('http://grafana.example.com')
+ grafana.withTheme('dark')
+ grafana.withAnonymous()

// Plugins
+ grafana.addPlugin('fetzerch-sunandmoon-datasource')

// Datasources
+ grafana.addDatasource('Prometheus', datasources.prometheus)
+ grafana.addDatasource('NYC', datasources.sun_and_moon)

// Dashboards
// + grafana.addDashboard('node-exporter-full', dashboards.node_exporter, 'Node Exporter')
+ grafana.addDashboard('nyc', dashboards.nyc, 'Sun and Moon')

// Mixins
+ grafana.addMixinDashboards(mixins)

+ tempo {
  _images+:: {
    // override images here if desired
  },

  _config+:: {
    namespace: 'default',
    pvc_size: '30Gi',
    pvc_storage_class: 'local-path',
    receivers: {
      jaeger: {
        protocols: {
          thrift_http: null,
        },
      },
    },
  },

  local k = import 'ksonnet-util/kausal.libsonnet',
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  tempo_container+::
    container.withPortsMixin([
      containerPort.new('jaeger-http', 14268),
    ]),

  local ingress = k.networking.v1.ingress,
  local rule = k.networking.v1.ingressRule,
  local path = k.networking.v1.httpIngressPath,
  ingress:
    ingress.new('ingress') +
    ingress.mixin.metadata
    .withAnnotationsMixin({
      'ingress.kubernetes.io/ssl-redirect': 'false',
    }) +
    ingress.mixin.spec.withRules(
      rule.http.withPaths([
        path.withPath('/')
        + path.withPathType('ImplementationSpecific')
        + path.backend.service.withName('grafana')
        + path.backend.service.port.withNumber(3000),
      ]),
    ),
}

+ prometheus {
  _config+:: {
    cluster_name: 'cluster1',
    namespace: 'default',
  },
}
