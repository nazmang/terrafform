locals {
  # Zone of the cluster tunnel hosts; var.cloudflare_domain_name is srvxapp.com.
  srvx_cc = "srvx.cc"

  cloudflare_tunnels = {
    jenkins = {
      zone_type = "CNAME"
      tunnel_config = {
        ingress = [
          {
            service = "http://gateway:80"
          },
        ]
      }
    },
    ingress = {
      zone_type = "CNAME"
      tunnel_config = {
        ingress = [
          # Every *.srvx.cc host goes to the kgateway Gateway `public` (k8s
          # helm-kgateway); a host without an HTTPRoute gets 404 from kgateway.
          # ingress-nginx is gone (kgw-09). DNS records come from external-dns.
          {
            hostname = "*.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            service = "http_status:404"
          }
        ]
      }
    },
    hassio = {
      zone_type = "CNAME"
      tunnel_config = {
        ingress = [
          {
            service = "http://192.168.88.152:8123"
          },
        ]
      }
    }
  }
}
