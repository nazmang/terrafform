Ansible Role: Install Nginx
=========

This role installs and configures the latest version of Nginx from apt repository.

Requirements
------------

None.

Role Variables
--------------
```yaml
nginx_upstreams: []
```
If you are configuring Nginx as a load balancer, you can define one or more upstream sets using this variable.
```yaml
nginx_user: "www-data"
```
The user under which Nginx will run. Defaults to `www-data` for Debian like systems.
```yaml
nginx_worker_connections: "1024"
```
`nginx_worker_processes` should be set to the number of cores present on your machine

```yaml
 nginx_log_format: |-
      '$remote_addr - $remote_user [$time_local] "$request" '
      '$status $body_bytes_sent "$http_referer" '
      '"$http_user_agent" "$http_x_forwarded_for"'
```

Configures Nginx's [`log_format`](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format). options. 


Dependencies
------------

None.

Example Playbook
----------------
```yaml
 - hosts: all
   vars:
     nginx_upstreams:
       - name: backend1
         domain: "example.com"
         keepalive: 32
         servers:
           - "srv1.example.com"
           - "srv2.example.com weight=5"

   roles:
     - { role: install-nginx }
```

License
-------

BSD

