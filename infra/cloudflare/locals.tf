locals {
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
