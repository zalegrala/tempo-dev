{
  local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet',
  local configMap = k.core.v1.configMap,
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local deployment = k.apps.v1.deployment,
  local volume = k.core.v1.volume,
  local volumeMount = k.core.v1.volumeMount,

  local google_creds = 'google-creds',

  usage_stats_container::
    container.new('usage-stats', 'us.gcr.io/kubernetes-dev/usage-stats-handler:latest') +
    container.withPorts([
      containerPort.new('usage-metrics', 80),
    ]) +
    container.withCommand([
      '/bin/usage-stats-handler',
      '-usage-stats.redis.server=redis:6379',
      '-log.level=debug',
    ]) +
    container.withVolumeMounts([
      volumeMount.new(google_creds, '/root/.config/gcloud/application_default_credentials.json'),
    ]),

  usage_stats_deployment:
    deployment.new('usage-stats',
                   1,
                   [$.usage_stats_container],
                   { app: 'usage_stats' })
    + deployment.mixin.spec.template.spec.withVolumes([
      volume.fromHostPath(google_creds, '/root/.config/gcloud/application_default_credentials.json')
      + volume.hostPath.withType('File'),
    ]),

  usage_stats_service:
    k.util.serviceFor($.usage_stats_deployment),
}
