# Terraform Hetzner Cloud & WireGuard Configuration

This Terraform configuration manages resources in Hetzner Cloud and configures SSH and WireGuard VPN for secure server access and tunneling. Docker will be installed on both servers for further use.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed on your local machine.
- Hetzner Cloud API token.
- SSH public and private keys for secure remote access.
- WireGuard configuration for secure tunneling.

## Variables

### Hetzner Cloud Configuration

| Variable             | Description                                | Type   | Default |
|----------------------|--------------------------------------------|--------|---------|
| `hcloud_token`        | The API token for Hetzner Cloud.           | string | N/A     |
| `firewall_allowed_ips`| List of IPs allowed to connect to the server(s). | list   | `["0.0.0.0/0", "::/0"]` |

### SSH Configuration

| Variable               | Description                                | Type   | Default               |
|------------------------|--------------------------------------------|--------|-----------------------|
| `ssh_public_key_path`   | Path to your SSH public key file.          | string | `~/.ssh/id_rsa.pub`    |
| `ssh_private_key_path`  | Path to your SSH private key for SSH connections. | string | `~/.ssh/id_rsa`        |
| `ssh_user`              | User for SSH connections.                  | string | `root`                 |

### WireGuard Configuration

| Variable                  | Description                                  | Type   | Default       |
|---------------------------|----------------------------------------------|--------|---------------|
| `remote_host_public_key`   | WireGuard remote host public key.            | string | N/A           |
| `remote_host_ip`           | WireGuard remote host IP address.            | string | N/A           |
| `remote_allowed_ips`       | List of allowed IPs for the WireGuard tunnel. | list   | `["0.0.0.0/0"]`|
| `remote_host_port`         | WireGuard remote host port.                  | string | `51820`        |
| `wg_private_key`           | WireGuard private key for the local client.  | string | N/A           |

## Usage

1. Clone this repository.
2. Ensure you have your variables properly set in a `terraform.tfvars` file or passed in as environment variables or directly in your Terraform plan.
3. Initialize your Terraform working directory:
    ```sh
    terraform init
    ```
4. Review the planned actions:
    ```sh
    terraform plan
    ```
5. Apply the configuration:
    ```sh
    terraform apply
    ```

## Example `terraform.tfvars`

Here is an example `terraform.tfvars` file you can use to pass variables:

```hcl
hcloud_token         = "your-hcloud-token"
ssh_public_key_path  = "~/.ssh/id_rsa.pub"
ssh_private_key_path = "~/.ssh/id_rsa"
ssh_user             = "root"
remote_host_public_key = "your-wireguard-remote-host-public-key"
remote_host_ip       = "192.168.1.1"
remote_allowed_ips   = ["0.0.0.0/0"]
wg_private_key       = "your-wireguard-private-key"
```

## Notes

- Be sure to securely manage your API tokens and SSH keys.
- Review the firewall rules to ensure only trusted IPs are allowed to connect to the server.
- Use the WireGuard configuration to create a secure VPN tunnel to your remote server.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
