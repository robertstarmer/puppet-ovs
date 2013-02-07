define ovs::add-port (
  $port = $title,
  $bridge,
  $ensure = "present",
 ) 
 {
 if "$ensure" == "absent" {
  exec {"del-port-$port":
   command => "/usr/bin/ovs-vsctl del-port $bridge $port",
   onlyif => "/usr/bin/ovs-vsctl list-ports $bridge | /bin/grep $port",
  }
 } else {
  exec {"ovs-add-port-$port":
   command => "/usr/bin/ovs-vsctl add-port $bridge $port",
   unless => "/usr/bin/ovs-vsctl list-ports $bridge | /bin/grep $port", 
  }
 } 
}
