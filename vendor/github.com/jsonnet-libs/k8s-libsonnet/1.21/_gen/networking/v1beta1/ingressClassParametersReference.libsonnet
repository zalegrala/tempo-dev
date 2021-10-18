{
  local d = (import 'doc-util/main.libsonnet'),
  '#':: d.pkg(name='ingressClassParametersReference', url='', help='IngressClassParametersReference identifies an API object. This can be used to specify a cluster or namespace-scoped resource.'),
  '#withApiGroup':: d.fn(help='APIGroup is the group for the resource being referenced. If APIGroup is not specified, the specified Kind must be in the core API group. For any other third-party types, APIGroup is required.', args=[d.arg(name='apiGroup', type=d.T.string)]),
  withApiGroup(apiGroup): { apiGroup: apiGroup },
  '#withKind':: d.fn(help='Kind is the type of resource being referenced.', args=[d.arg(name='kind', type=d.T.string)]),
  withKind(kind): { kind: kind },
  '#withName':: d.fn(help='Name is the name of resource being referenced.', args=[d.arg(name='name', type=d.T.string)]),
  withName(name): { name: name },
  '#withNamespace':: d.fn(help='Namespace is the namespace of the resource being referenced. This field is required when scope is set to "Namespace" and must be unset when scope is set to "Cluster".', args=[d.arg(name='namespace', type=d.T.string)]),
  withNamespace(namespace): { namespace: namespace },
  '#withScope':: d.fn(help='Scope represents if this refers to a cluster or namespace scoped resource. This may be set to "Cluster" (default) or "Namespace". Field can be enabled with IngressClassNamespacedParams feature gate.', args=[d.arg(name='scope', type=d.T.string)]),
  withScope(scope): { scope: scope },
  '#mixin': 'ignore',
  mixin: self,
}
