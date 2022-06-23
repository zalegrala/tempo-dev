local agent = import 'agent.libsonnet';
local grafana = import 'grafana.libsonnet';
// local loki = import 'loki.libsonnet';
local prometheus = import 'prometheus.libsonnet';
local tempo = import 'tempo.libsonnet';

// local usage_stats = import 'usage_stats/usage_stats.libsonnet';

local minio = import 'minio/minio.libsonnet';
local redis = import 'redis/redis.libsonnet';


grafana
+ tempo
+ prometheus
+ agent
// + loki

// + usage_stats

+ minio
+ redis
  {

  local local_config = import '../../config.json',

  _images+:: {
    // images can be overridden here if desired
    tempo: 'grafana/tempo:latest',
  },

  _config+:: {
    cluster: 'k3d-local-dev',
    namespace: 'default',

    grafana_cloud: local_config.grafana_cloud,

    // whether to send traces to local Tempo, this creates a feedback loop but
    // results in more and richer traces
    self_ingest: false,
  },

  tempo_config+: {
    metrics_generator_enabled: false,
    search_enabled: false,
    // usage_report: {
    //   reporting_enabled: true,
    // },

    memberlist: {
      abort_if_cluster_join_fails: false,
      bind_port: 7946,
      join_members: [
        'gossip-ring:7946',
      ],
    },

    // distributor+: {
    //   log_received_spans: {
    //     enabled: true,
    //   },
    // },

    querier+: {
      query_timeout: '10m',
      frontend_worker+: {
        grpc_client_config: {
          max_recv_msg_size: 90000000,
          max_send_msg_size: 90000000,
        },
      },
    },

    server+: {
      grpc_server_max_recv_msg_size: 1.048576e+08,
      grpc_server_max_send_msg_size: 1.048576e+08,
    },

    overrides+: {
      max_bytes_per_trace: 500000000,
      max_search_bytes_per_trace: 500000,
    },

  },

}
