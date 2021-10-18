# tempo-dev

## Init
    k3d cluster create tempo --api-port 6443 --port "3000:80@loadbalancer"
    tk apply environments/default


## Teardown

    k3d cluster delete tempo
