$bridge = "br-ex"
$port = "eth0"

class { 'ovs': }
-> 
ovs::add-br {"br-ex": ensure=>'present'}
->
ovs::add-port {"eth0": bridge => 'br-ex', ensure => 'present'}


define match_interfaces {
    if $name =~ /$bridge/ {
      exec {"/sbin/ifconfig $bridge $ipaddress_eth0 netmask $netmask_eth0 up":
       onlyif => "/sbin/ip add show | grep $port | grep inet",
      }->
      exec {"sed -e \'s/$port/$bridge/\' -i /etc/network/interfaces":
         refreshonly=> true,
      }
    }
    if $name =~ /$port/ {
      exec {"/sbin/ifconfig $port 0.0.0.0 up":
       onlyif => "/sbin/ip addr show | grep $port | grep inet",
      } ->
      exec {"echo -e \'auto $port\niface $port inet static\n\taddress 0.0.0.0\n\' >> /etc/network/interfaces":
       refreshonly => true,
      }
    }
}

$array_of_interfaces = split($interfaces, ',')
 
match_interfaces { $array_of_interfaces: }

