listen {
  port = 4040
}

namespace "server1_namespace" {
  format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\" $request_time \"$request_uri\""
  source {
    files = [
      "/var/log/nginx/nazmang-prom.srvx.cc_access.log"
    ]
  }
  relabel "request_time" { from = "request_time" }
  relabel "request_uri" { from = "request_uri" }
  labels {
    server = "server1"
  }
}

namespace "server2_namespace" {
  format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\" $request_time \"$request_uri\""
  source {
    files = [
      "/var/log/nginx/access.log"
    ]
  }
  relabel "request_time" { from = "request_time" }
  relabel "request_uri" { from = "request_uri" }
  labels {
    server = "server2"

  }
}