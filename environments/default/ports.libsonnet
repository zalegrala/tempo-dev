{
  local k = import 'ksonnet-util/kausal.libsonnet',

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
        path.withPath('/prometheus')
        + path.withPathType('ImplementationSpecific')
        + path.backend.service.withName('prometheus')
        + path.backend.service.port.withNumber(9090),
      ]),
    ),
}
