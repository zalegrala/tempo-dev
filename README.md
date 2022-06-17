# tempo-dev

This is a local development environment using Tilt, jsonnet, and k3d.

Requirements:
* Tilt
* jsonnet-bundler
* k3d

## Init

    make run

## Teardown

    k3d cluster delete local-dev
