Simple ovs init
===============

Simple puppet to install and initialize OVS on an Uubntu 12.04 system
running libvirt-bin/kvm

Based on http://blog.allanglesit.com/2012/03/linux-kvm-ubuntu-12-04-with-openvswitch/

For single interface systems (e.g. only eth0 attached):

Change /etc/network/interfaces:

	auto eth0
	iface eth0 inet static
		address 0.0.0.0
		netmask 255.255.255.255

	auto br-ex
	iface br-ex inet static
		address {public_ip}
		netmask {public_netmask}
		gateway {public_gateway}
		dns-nameserver {public_nameserver}
		dns-search {public_search}

Then, run:

	ovs-vsctl add-br br-ex; ovs-vsctl add-port br-ex eth0 ; reboot

CC-SA 2013
