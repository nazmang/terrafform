# vpn-do

> Digital Ocean based VPN server

Terraform plan to deploy Digital Ocean based VPN server. Both IPsec and OpenVPN will be used. 

## Usage
#### for Linux
- Prepare SSH key pair that will be used to access your droplet
- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli "Terraform") and clone this repo
- Copy and edit `terraform.tfvars` according your DO project settings (Token, SSH keys, domain etc.)
```sh
cp terraform.tfvars.sample terraform.tfvars
```
- and run
```sh
terrform apply -auto-approve 
```

#### for Windows
The same steps as for Linux setup. Please check if you have *OpenSSH* client installed https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
####outputs

```sh
Outputs:

server_fqdn = "your.fqdn"
server_ip = "64.X.X.X"

```

## Configure clients
All neccessary files for clients configuring willbe downloadautomatically to source flderon youl local machine.
- [OpenVPN](https://openvpn.net/community-downloads/ "OpenVPN")  - just import `client.ovpn` file in *Import* menu on client. 
- [strongSwan](https://play.google.com/store/apps/details?id=org.strongswan.android "strongSwan") for Android - you need to import `vpnclient.sswan` file on you cell. See details on https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/ikev2-howto.md#android
- iOS - you will need `vpnclient.mobileconfig` file. See details on https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/ikev2-howto.md#ios
- `vpnclient.p12` - certificate chain file you migh use in hardware like *Mikotik* routers. See details on https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/ikev2-howto.md#routeros 



## Acknowledgments

Based on automatic installation scripts
- https://github.com/hwdsl2/setup-ipsec-vpn
- https://github.com/angristan/openvpn-install

## Features
- Fast deployment using Terraform.
- Cheap, starts from 5$ per month.
- You can choose between IPSec and OpenVPN technologies. 
- Muliple clients support (Windows, Linux, Android, iOS).


