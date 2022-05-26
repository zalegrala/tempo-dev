local grafana = import 'grafana.libsonnet';
local loki = import 'loki.libsonnet';
local minio = import 'minio/minio.libsonnet';
local prometheus = import 'prometheus.libsonnet';
local tempo = import 'tempo.libsonnet';

grafana
+ tempo
+ prometheus
+ loki
+ minio
  {

  local local_config = import '../../config.json',

  _images+:: {
    // images can be overridden here if desired
  },

  _config+:: {
    cluster: 'k3d-local-dev',
    namespace: 'default',

    // whether to send traces to local Tempo, this creates a feedback loop but
    // results in more and richer traces
    self_ingest: false,
  },
}
