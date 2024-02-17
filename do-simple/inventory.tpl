%{ for index, name in droplet_names ~}
${ name } ansible_host=${ droplet_ip_address[index] } ansible_user=${ droplet_user } 
%{ endfor ~}

%{ for index, name in droplet_names ~}
%{ if strcontains(name, "elk") ~}
[elk]
${ name } ansible_host=${ droplet_ip_address[index] } ansible_user=${ droplet_user }
%{ endif ~}
%{ endfor ~}
