%{ for index, name in droplet_names ~}
${ name } ansible_host=${ droplet_ip_address[index] } ansible_user=${ droplet_user } ansible_ssh_private_key_file=private.key 
%{ endfor ~}