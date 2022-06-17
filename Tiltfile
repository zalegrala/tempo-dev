tempo_dir = decode_json(read_file('config.json'))['tempo_dir']
usage_stats_dir = decode_json(read_file('config.json'))['usage_stats_dir']

# Docker builds

custom_build(
    'grafana/tempo',
    'cd ' + tempo_dir + ' && make docker-tempo',
    tag='latest',
    deps=[tempo_dir + 'cmd/tempo/', tempo_dir + 'modules/', tempo_dir + 'pkg/', tempo_dir + 'tempodb', tempo_dir + 'vendor/'],
)
custom_build(
    'grafana/tempo-query',
    'cd ' + tempo_dir + ' && make docker-tempo-query',
    tag='latest',
    deps=[tempo_dir + 'cmd/tempo-query/', tempo_dir + 'vendor/'],
)
custom_build(
    'grafana/tempo-vulture',
    'cd ' + tempo_dir + ' && make docker-tempo-vulture',
    tag='latest',
    deps=[tempo_dir + 'cmd/tempo-vulture/', tempo_dir + 'vendor/'],
)
custom_build(
    'us.gcr.io/kubernetes-dev/usage-stats-handler',
    'cd ' + usage_stats_dir + ' && make build docker',
    tag='latest',
    deps=[usage_stats_dir],
)

# Kubernetes

yaml = local('tk show --dangerous-allow-redirect tk/environments/tempo')
k8s_yaml(yaml)

k8s_resource('kube-state-metrics', labels=["k8s"])

# Supporting observability
k8s_resource('grafana', port_forwards='3000', labels=['LGtM'])
k8s_resource('prometheus', port_forwards=['9090'], labels=['LGtM'])
k8s_resource('read', port_forwards=['3100'], labels=['LGtM']) # loki
k8s_resource('write', port_forwards=['9095'], labels=['LGtM']) # loki
k8s_resource('promtail', labels=['LGtM']) # loki

# Tempo
k8s_resource('query-frontend', port_forwards=['3200', '16686'], labels=['tempo']) # tempo
k8s_resource('querier', port_forwards=['3201'], labels=['tempo'])
k8s_resource('distributor', port_forwards=['3202', '4317', '14250'], labels=['tempo'])
k8s_resource('ingester', port_forwards=['3203'], labels=['tempo'])
k8s_resource('compactor', port_forwards=['3205'], labels=['tempo'])
k8s_resource('metrics-generator', labels=['tempo'])
k8s_resource('vulture', labels=['tempo'])
#k8s_resource('memcached', labels=['tempo'])

k8s_resource('usage-stats', port_forwards=['8080'], labels=["usage-stats"])

# Storage and cache support
k8s_resource('minio', port_forwards=['9000', '9010'], labels=["storage"])
k8s_resource('redis', port_forwards=['6379'], labels=["storage"])

