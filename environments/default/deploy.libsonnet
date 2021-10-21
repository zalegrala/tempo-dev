local minio = import 'minio/minio.libsonnet';
local tempo = import 'tempo/tempo.libsonnet';

minio +

tempo {
  _images+:: {
    // images can be overridden here if desired
  },

  _config+:: {
    namespace: 'default',
    compactor+: {
    },
    querier+: {
      replicas: 3,
    },
    ingester+: {
      pvc_size: '5Gi',
      pvc_storage_class: 'local-path',
    },
    distributor+: {
      receivers: {
        opencensus: null,
        jaeger: {
          protocols: {
            grpc: {
              endpoint: '0.0.0.0:14250',
            },
          },
        },
      },
    },
    memcached+: {
      replicas: 1,
    },
    vulture+: {
      replicas: 1,
      tempoRetentionDuration: '1h',
      tempoSearchBackoffDuration: '7s',
      tempoReadBackoffDuration: '5s',
      tempoWriteBackoffDuration: '10s',
    },
    backend: 's3',
    bucket: 'tempo',
    tempo_query_url: 'http://query-frontend:3200',
  },

  // manually overriding to get tempo to talk to minio
  tempo_config+:: {
    storage+: {
      trace+: {
        s3+: {
          endpoint: 'minio:9000',
          access_key: 'tempo',
          secret_key: 'supersecret',
          insecure: true,
        },
      },
    },
  },

  local k = import 'ksonnet-util/kausal.libsonnet',
  local service = k.core.v1.service,
  tempo_service:
    k.util.serviceFor($.tempo_distributor_deployment)
    + service.mixin.metadata.withName('tempo'),

  local container = k.core.v1.container,
  local containerPort = k.core.v1.containerPort,
  tempo_compactor_container+::
    k.util.resourcesRequests('500m', '500Mi'),

  tempo_distributor_container+::
    k.util.resourcesRequests('500m', '500Mi') +
    container.withPortsMixin([
      containerPort.new('opencensus', 55678),
      containerPort.new('jaeger-http', 14268),
      containerPort.new('jaeger-grpc', 14250),
    ]),

  tempo_ingester_container+::
    k.util.resourcesRequests('500m', '500Mi'),

  // clear affinity so we can run multiple ingesters on a single node
  tempo_ingester_statefulset+: {
    spec+: {
      template+: {
        spec+: {
          affinity: {},
        },
      },
    },
  },

  tempo_querier_container+::
    k.util.resourcesRequests('500m', '500Mi'),

  tempo_query_frontend_container+::
    k.util.resourcesRequests('300m', '500Mi'),

  // clear affinity so we can run multiple instances of memcached on a single node
  memcached_all+: {
    statefulSet+: {
      spec+: {
        template+: {
          spec+: {
            affinity: {},
          },
        },
      },
    },
  },
}