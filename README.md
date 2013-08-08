weewee
======

Wrapper Extension Engine for veewee

A ruby script of generating veewee templates based on some defaults

Currently has basic functionality for Linux. Planning to add Solaris.

Usage
=====

	weewee.rb -[h|V] -[l|s] -[k|p|d] -D -o [OUTPUT]

	-V:          Display version information
	-h:          Display usage information
	-k:          Create kickstart file (Also sets OS type to Linux)
	-l:          Set OS to Linux
	-p:          Create postinstall file
	-d:          Create definitions file
	-D:          Use defaults
	-o: OUTPUT   Output file

Examples
========

Generate Linux Kickstart file and review defaults:

	$ /weewee.rb -l -k
	OS Type is Linux
	Loading ./methods/definition.rb
	Loading ./methods/kickstart.rb
	Loading ./methods/postinstall.rb

	You will be presented with a set of questions followed by the default output
	If you are happy with the default output simply hit enter

	Install type?
	[ install ]
  
	Install Medium?
	[ cdrom ]
  
	Install Language?
	[ en_US.UTF-8 ]

Generate Linux Kickstart file to STDOUT and accept defaults:

	$ weewee.rb -l -k -D 
	OS Type is Linux
	Loading ./methods/definition.rb
	Loading ./methods/kickstart.rb
	Loading ./methods/postinstall.rb
	# weewee (Wrapper Extension Engine for veewee) v. 0.0.1 Richard Spindler <richard@lateralblast.com.au>
	install
	cdrom
	lang en_US.UTF-8
	langsupport --default=en_US.UTF-8 en_US.UTF-8
	keyboard us
	rootpw --iscrypted $1Eos8GLxaqSA
	network --device eth0 --bootproto dhcp
	selinux --enforcing
	authconfig --enableshadow --enablemd5
	timezone Australia/Melbourne
	bootloader --location=mbr
	clearpart --all --drives=sda --initlabel
	part /boot --fstype ext3 --size=100 --ondisk=sda
	part pv.2 --size=0 --grow --ondisk=sda
	volgroup VolGroup00 --pesize=32768 pv.2
	logvol swap --fstype swap --name=LogVol01 --vgname=VolGroup00 --size=512 --grow --maxsize=1024
	logvol / --fstype ext3 --name=LogVol00 --vgname=VolGroup00 --size=1024 --grow
	reboot

	%packages
	@ core
	grub
	e2fsprogs
	lvm2
	kernel-devel
	kernel-headers

	%post
	/usr/sbin/groupadd vagrant
	/usr/sbin/useradd vagrant -g vagrant -G wheel
	echo "vagrant"|passwd --stdin vagrant
	echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

Generate Linux Kickstart file ks.cfg  and accept defaults:
	
	$ weewee.rb -l -k -D -o ks.cfg

Generate Definitions file to STDOUT and accept defaults:

	$ weewee.rb -l -d -D
	OS Type is Linux
	Loading ./methods/definition.rb
	Loading ./methods/kickstart.rb
	Loading ./methods/postinstall.rb
	Veewee::Session.declare({
	  :cpu_count => "1",
	  :memory_size => "384",
	  :disk_size => "10240",
	  :disk_format => "VDI",
	  :hostiocache => "off",
	  :ioapic => "on",
	  :pae => "on",
	  :os_type_id => "RedHat_64",
	  :boot_wait => "10",
	  :iso_src => "CentOS-5.9-x86_64-bin-DVD-1of2.iso",
	  :iso_md5 => "",
	  :iso_download_timeout => "10000",
	  :boot_cmd_sequence => "[ 'linux text ks=http://%IP%:%PORT%/ks.cfg<Enter>' ]",
	  :kickstart_port => "7122",
	  :kickstart_timeout => "10000",
	  :kickstart_file => "ks.cfg",
	  :ssh_login_timeout => "10000",
	  :ssh_user => "vagrant",
	  :ssh_password => "vagrant",
	  :ssh_key => "",
	  :ssh_host_port => "7222",
	  :ssh_guest_port => "22",
	  :shutdown_cmd => "/sbin/halt -h -p",
	  :postinstall_files => "[ 'postinstall.sh' ]",
	  :postinstall_timeout => "10000"
	})

