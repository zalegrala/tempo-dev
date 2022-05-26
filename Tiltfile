tempo_dir = decode_json(read_file('config.json'))['tempo_dir']

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

# Kubernetes

yaml = local('tk show --dangerous-allow-redirect tk/environments/tempo')
k8s_yaml(yaml)

k8s_resource('grafana', port_forwards='3000')
k8s_resource('prometheus', port_forwards=['9090'])
k8s_resource('read', port_forwards=['3100']) # loki

k8s_resource('query-frontend', port_forwards=['3200', '16686']) # tempo
k8s_resource('querier', port_forwards=['3201'])
k8s_resource('distributor', port_forwards=['3202', '4317', '14250'])
k8s_resource('ingester', port_forwards=['3203'])
k8s_resource('compactor', port_forwards=['3205'])

k8s_resource('minio', port_forwards=['9000', '9010'])

