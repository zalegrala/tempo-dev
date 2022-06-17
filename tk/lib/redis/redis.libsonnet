{
  local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet',
  local configMap = k.core.v1.configMap,
  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  local deployment = k.apps.v1.deployment,

  redis_container::
    container.new('redis', 'redis:latest') +
    container.withPorts([
      containerPort.new('redis', 6379),
    ]),

  redis_deployment:
    deployment.new('redis',
                   1,
                   [$.redis_container],
                   { app: 'redis' }),

  redis_service:
    k.util.serviceFor($.redis_deployment),
}
