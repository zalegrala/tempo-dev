# tempo-dev

This is a local development environment to aid in a full deployment using the tk + jsonnet + k3d stack.

## Init

    k3d cluster create tempo --api-port 6443 --port "3000:80@loadbalancer"

    export CONTEXT=$(kubectl config current-context)
    tk env set environments/default  --server-from-context=$CONTEXT

    tk apply environments/default


## Teardown

    k3d cluster delete tempo
