TEMPO_DIR := $(shell cat ../config.json | jq -r .tempo_dir)

vendor:
	@jb update
	@ln -s $(TEMPO_DIR)/operations/jsonnet/microservices vendor/microservices
	@ln -s $(TEMPO_DIR)/operations/tempo-mixin vendor/tempo-mixin
	@ln -s $(TEMPO_DIR)/example/tk/lib/minio vendor/minio

.PHONY: vendor
