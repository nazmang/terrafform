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
          # Hosts moved to kgateway (k8s helm-kgateway); must stay above the wildcard.
          {
            hostname = "alertmanager.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "argocd.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "uptime-kuma.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "semaphore.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "ktulu.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "ntfy.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "vault.srvx.cc"
            service  = "http://public.kgateway-system.svc.cluster.local:80"
          },
          {
            hostname = "*.srvx.cc"
            service  = "http://ingress-nginx-controller.ingress-nginx.svc.cluster.local:80"
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
