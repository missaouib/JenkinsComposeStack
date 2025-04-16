# Run Docker Registry with TLS

There are many instances that I need to do this. Especially if I am installing K8s in an internet restricted environment (example: [Install TKG in Internet restricted env][install-tkg-internet-restricted])

So I like to use [docker registry][docker-registry] and [mkcert][mkcert] to play with this scenario

1. Create directories for certs and data

    ```bash
    mkdir -p data certs
    ```
    

1. Install Mkcert. Just curl and install binary. See [project][mkcert] for more instruction

1. Create CA

    ```bash
    mkcert -install
    ```

1. Copy CA cert into certs directory

    ```bash
    cp  $(mkcert -CAROOT)/rootCA.pem certs/ca.crt
    ```

1. Generate certificate

    ```bash
    mkcert -cert-file certs/registry.crt -key-file certs/registry.key localhost 192.168.1.1 tkg-bootstrap-registry.local
    ```

1. Run docker registry 

    ```bash
    docker \
      run \
      -d \
      --restart=always \
      --name registry \
      -v "${pwd}"/data:/var/lib/registry \
      -v "${pwd}"/certs:/certs \
      -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
      -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
      -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
      -p 443:443 \
      registry:2

    ```
    
    




[install-tkg-internet-restricted]: https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-mgmt-clusters-airgapped-environments.html
[tkg-gen-publish-images]: https://github.com/yogendra/pcf-tools/blob/master/scripts/gen-publish-images.sh
[docker-registry]: https://docs.docker.com/registry/deploying/
[mkcert]: https://github.com/FiloSottile/mkcert