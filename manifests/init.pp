class ovs {

  package { ["kvm","libvirt-bin","vlan","virtinst","virt-manager","virt-viewer","pv","openvswitch-controller","openvswitch-brcompat","openvswitch-switch","openvswitch-datapath-source"]:
  ensure => 'latest',
  }

  package {'ebtables':
    ensure => 'absent',
  }

  exec { "module-build-ovs":
    command=>"module-assistant auto-install openvswitch-datapath",
    path=>["/usr/bin","/bin","/sbin"],
    unless => 'ovs-vsctl show',
  }

  exec { "virsh-net-destroy":
    path=>["/usr/bin","/bin","/sbin"],
    command=>"virsh net-destroy default",
    notify => Exec["virsh-net-autostart"],
    onlyif => 'brctl show | grep virbr0',
 
  }

  exec { "virsh-net-autostart": 
   path=>["/usr/bin","/bin","/sbin"],
   command=>"virsh net-autostart --disable default",
   refreshonly => true,
  }

  exec { "ovs-brcompat":
   path => ["/bin","/sbin","/usr/bin"],
   command => "sed -e 's/.*BRCOMPAT=.*/BRCOMPAT=yes/' -i /etc/default/openvswitch-switch",
   onlyif => 'grep "BRCOMPAT=no" /etc/default/openvswitch-switch',
   notify => Service["openvswitch-switch","openvswitch-controller"],
  }

  service { "openvswitch-switch":
   restart => true,
  }

  service { "openvswitch-controller":
   restart => true,
  }
}