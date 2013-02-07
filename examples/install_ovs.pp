class { 'ovs': }
-> 
ovs::add-br {"br-ex": ensure=>'present'}
->
ovs::add-port {"eth0": bridge => 'br-ex', ensure => 'present'}
