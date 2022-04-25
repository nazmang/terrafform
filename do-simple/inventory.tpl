%{ for index, name in droplet_names ~}
${ name } ansible_host=${ droplet_ip_address[index] } ansible_user=${ droplet_user } 
%{ endfor ~}