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
      # tunnel_config = {
      #   ingress = [
      #     {
      #       hostname = "jenkins.${var.cloudflare_domain_name}"
      #       service  = "http://gateway:80"
      #     },
      #     {
      #       hostname = "jenkins.${var.cloudflare_domain_name}/github-webhook/"
      #       service  = "http://gateway:80"
      #       origin_request = {
      #         ip_rules = [
      #           {
      #             ip    = "192.30.252.0/22"
      #             allow = true
      #           },
      #           {
      #             ip    = "185.199.108.0/22"
      #             allow = true
      #           },
      #           {
      #             ip    = "140.82.112.0/20"
      #             allow = true
      #           },
      #           {
      #             ip    = "143.55.64.0/20"
      #             allow = true
      #           },
      #         ]
      #       }
      #     },
      #     {
      #       service = "http://jenkins:80"
      #     }
      #   ]
      # }
    }
  }
}
