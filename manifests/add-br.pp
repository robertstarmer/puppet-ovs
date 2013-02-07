define ovs::add-br (
  $bridge = $title,
  $ensure = "present",
  $parent-bridge = false,
  $vlan = false,
 ) 
 {
 if "$ensure" == "absent" {
  exec {"del-br-$bridge":
   command => "/usr/bin/ovs-vsctl del-br $bridge",
   onlyif => "/usr/bin/ovs-vsctl list-br | /bin/grep $bridge",
  }
 } else {
  if $parent-bridge and ! $vlan {
    notify {"Defined parent bridge without vlan in bridge create": }
  } elsif ! $parent-bridge and $vlan {
    notify {"Defined vlan without parent bridge in bridge create": }
  } else {
   exec {"ovs-add-br-$bridge":
    command => "/usr/bin/ovs-vsctl add-br $bridge",
    unless => "/usr/bin/ovs-vsctl list-br | /bin/grep $bridge", 
   }
  }
 } 
}
