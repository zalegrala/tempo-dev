local k = import 'ksonnet-util/kausal.libsonnet',
      loki = import 'loki-simple-scalable/loki.libsonnet',
      promtail = import 'promtail/promtail.libsonnet',
      grpc_listen_port = 9095,
      s3Url = 's3://admin:supersecret@minio:9000/loki',
      pvc = k.core.v1.persistentVolumeClaim;

loki
+ promtail
  {
  _images+:: {
    loki: 'grafana/loki:2.5.0',
  },

  _config+:: {

    promtail_config+: {
      clients: [{
        scheme:: 'http',
        hostname:: 'write',
        external_labels: {},
      }],
    },

    headless_service_name: 'loki',
    http_listen_port: 3100,
    read_replicas: 1,
    write_replicas: 1,
    loki: {
      auth_enabled: false,
      server: {
        http_listen_port: $._config.http_listen_port,
        grpc_listen_port: grpc_listen_port,
      },
      memberlist: {
        join_members: [
          '%s.%s.svc.cluster.local' % [$._config.headless_service_name, $._config.namespace],
        ],
      },
      common: {
        path_prefix: '/loki',
        replication_factor: 1,
        storage: {
          s3: {
            s3: s3Url,
            s3forcepathstyle: true,
            insecure: true,
            endpoint: 'minio:9000',
          },
        },
      },
      limits_config: {
        enforce_metric_name: false,
        reject_old_samples_max_age: '168h',  //1 week
        max_global_streams_per_user: 60000,
        ingestion_rate_mb: 75,
        ingestion_burst_size_mb: 100,
      },
      schema_config: {
        configs: [{
          from: '2021-09-12',
          store: 'boltdb-shipper',
          object_store: 's3',
          schema: 'v11',
          index: {
            prefix: '%s_index_' % $._config.namespace,
            period: '24h',
          },
        }],
      },
    },
  },

  write_pvc+::
    pvc.mixin.spec.withStorageClassName('local-path'),
  read_pvc+::
    pvc.mixin.spec.withStorageClassName('local-path'),
}
