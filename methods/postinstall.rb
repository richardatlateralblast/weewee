
def populate_date(cmd,os_type)
  cmd.push("")
  cmd.push("date > /etc/vagrant_box_build_time")
  return cmd
end

def populate_environment(cmd,os_type)
  cmd.push("")
  cmd.push("# Set up environment")
  cmd.push("echo 'Setting up environment'")
  if os_type == "solaris"
    cmd.push("PATH=/usr/bin:/usr/sbin:/opt/csw/bin:$PATH ; export PATH")
    cmd.push("yes|pkgadd -d http://mirror.opencsw.org/opencsw/pkgutil-`uname -p`.pkg all")
    cmd.push("crle -u -l /opt/csw/lib")
    cmd.push("gsed -i -e 's#^\#PATH=.*$#PATH=/opt/csw/bin:/usr/sbin:/usr/bin:/usr/ucb#g' -e 's#^\#SUPATH=.*$#SUPATH=/opt/csw/bin:/usr/sbin:/usr/bin:/usr/ucb#g' /etc/default/login")
    cmd.push("gsed -i -e 's#^\#PATH=.*$#PATH=/opt/csw/bin:/usr/sbin:/usr/bin:/usr/ucb#g' -e 's#^\#SUPATH=.*$#SUPATH=/opt/csw/bin:/usr/sbin:/usr/bin:/usr/ucb#g' /etc/default/su")
    cmd.push("pkgutil -U")
    cmd.push("pkgutil -y -i CSWwget CSWgtar CSWgsed CSWvim")
    cmd.push("pkgutil -y -i CSWreadline CSWzlib CSWossldevel")
    cmd.push("pkgutil -y -i CSWgmake CSWgcc4g++ CSWgcc4core")
  end
  if os_type == "linux"
    cmd.push("#kernel source is needed for vbox additions")
    cmd.push("yum -y install gcc bzip2 make kernel-devel-`uname -r`")
    cmd.push("yum -y install gcc-c++ zlib-devel openssl-devel readline-devel sqlite3-devel")
    cmd.push("yum -y install perl wget dkms")
    cmd.push("yum -y erase gtk2 libX11 hicolor-icon-theme freetype bitstream-vera-fonts wireless-tools")
    cmd.push("yum -y clean all")
    cmd.push("PATH=/usr/local/bin:$PATH")
  end
  return cmd
end

def populate_network(cmd,os_type)
  cmd.push("")
  cmd.push("# Set up network")
  cmd.push("echo 'Setting up network'")
  if os_type == "solaris"
    cmd.push("gsed -i -e 's/localhost/localhost loghost/g' /etc/hosts")
  end
  if os_type == "linux"
    cmd.push("sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0")
  end
  return cmd
end

def populate_end(cmd,os_type)
  cmd.push("")
  cmd.push("# Finish up")
  cmd.push("echo 'Finishing up'")
  if os_type == "solaris"
    cmd.push("exit")
  end
  return cmd
end

def populate_ruby(cmd,os_type)
  cmd.push("")
  cmd.push("# Install ruby")
  cmd.push("echp 'Installing ruby'")
  if os_type == "linux"
    cmd.push("#Installing ruby")
    cmd.push("cd /tmp")
    cmd.push("wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz ")
    cmd.push("tar xzvf ruby-1.9.2-p180.tar.gz")
    cmd.push("cd ruby-1.9.2-p180")
    cmd.push("./configure")
    cmd.push("make && make install")
    cmd.push("cd /tmp")
    cmd.push("rm -rf /tmp/ruby-1.9.2-p180")
    cmd.push("rm /tmp/ruby-1.9.2-p180.tar.gz")
    cmd.push("ln -s /usr/local/bin/ruby /usr/bin/ruby")
    cmd.push("ln -s /usr/local/bin/gem /usr/bin/gem")
  end
  if os_type == "solaris"
    cmd.push("CSWruby18-gcc4 CSWruby18-dev CSWruby18 CSWrubygems")
  end
  return cmd
end

def populate_chef(cmd,os_type)
  cmd.push("")
  cmd.push("# Install chef")
  cmd.push("echo 'Installing chef'")
  if os_type == "solaris"
    cmd.push("PATH=/opt/csw/bin:/opt/csw/gnu/:/opt/csw/gcc4/bin:$PATH ; export PATH")
  end
  cmd.push("gem install chef --no-ri --no-rdoc")
  return cmd
end

def populate_puppet(cmd,os_type)
  cmd.push("")
  cmd.push("# Install puppet")
  cmd.push("echo 'Installing puppet'")
  if os_type == "solaris"
    cmd.push("pkgutil -y -i CSWaugeas CSWrubyaugeas")
  end
  cmd.push("gem install puppet --no-ri --no-rdoc")
  return cmd
end

def populate_vagrant_keys(cmd,os_type)
  cmd.push("")
  cmd.push("# Install Vagrant ssh keys")
  if os_type == "linux"
    vagrant_home="/home/vagrant"
  end
  if os_type == "solaris"
    vagrant_home="/export/home/vagrant"
  end
  cmd.push("echo 'Installing vagrant keys'")
  cmd.push("mkdir #{vagrant_home}/.ssh")
  cmd.push("chmod 700 #{vagrant_home}/.ssh")
  cmd.push("cd #{vagrant_home}/.ssh")
  cmd.push("wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys")
  cmd.push("chown -R vagrant #{vagrant_home}/.ssh")
  return cmd
end

def populate_guest_additions(cmd,os_type,platform)
  cmd.push("")
  if platform.match(/vbox/)
    cmd.push("# Install VirtualBox guest additions")
    cmd.push("echo 'Installing VirtualBox guest additions'")
    if os_type == "linux"
      vagrant_home="/home/vagrant"
      cmd.push("VBOX_VERSION=$(cat #{vagrant_home}/.vbox_version)")
      cmd.push("cd /tmp")
      cmd.push("wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso")
      cmd.push("mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt")
      cmd.push("sh /mnt/VBoxLinuxAdditions.run")
      cmd.push("umount /mnt")
      cmd.push("rm VBoxGuestAdditions_$VBOX_VERSION.iso")
    end
    if os_type == "solaris"
      vagrant_home="/export/home/vagrant"
      cmd.push("VBOX_VERSION=`cat $HOME/.vbox_version`")
      cmd.push("cd /tmp")
      cmd.push("mkdir vboxguestmnt")
      cmd.push("mount -F hsfs -o ro `lofiadm -a $HOME/VBoxGuestAdditions_${VBOX_VERSION}.iso` /tmp/vboxguestmnt")
      cmd.push("cp /tmp/vboxguestmnt/VBoxSolarisAdditions.pkg /tmp/.")
      cmd.push("pkgtrans VBoxSolarisAdditions.pkg . all")
      cmd.push("yes|pkgadd -d . SUNWvboxguest")
      cmd.push("umount /tmp/vboxguestmnt")
      cmd.push("lofiadm -d /dev/lofi/1")
      cmd.push("rm $HOME/VBoxGuestAdditions_${VBOX_VERSION}.iso")
    end
  else
    if os_type == "linux"
      cmd.push("# Install VMware tools}")
      cmd.push("cd /tmp")
      cmd.push("mkdir -p /mnt/cdrom")
      cmd.push("mount -o loop /home/vagrant/linux.iso /mnt/cdrom")
      cmd.push("tar zxvf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/")
      cmd.push("/tmp/vmware-tools-distrib/vmware-install.pl -d")
      cmd.push("umount /mnt/cdrom")
      cmd.push("rm /home/vagrant/linux.iso")
    end
  end
  return cmd
end

def populate_sudoers(cmd,os_type)
  cmd.push("")
  cmd.push("# Set up sudoers")
  cmd.push("echo 'Setting up sudoers'")
  cmd.push("sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers")
  cmd.push("sed -i 's/^\(.*env_keep = \"\)/\\1PATH /' /etc/sudoers")
  cmd.push("test -f /etc/sudoers && grep -v \"vagrant\" \"/etc/sudoers\" 1>/dev/null 2>&1 && echo \"vagrant ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers")
  return cmd
end

def populate_mdns(cmd,os_type)
  cmd.push("")
  cmd.push("#mDNS")
  if os_type == "linux"
    cmd.push("yum -y install avahi")
    cmd.push("chkconfig avahi-daemon on")
    cmd.push("sed -i 's/dns/& mdns/g' /etc/nsswitch.conf")
    cmd.push("service avahi-daemon start")
  end
  return cmd
end

def populate_rsyslog(cmd,os_type)
  cmd.push("")
  cmd.push("#rsyslog")
  if os_type == "linux"
    cmd.push("service syslog stop")
    cmd.push("chkconfig syslog off")
    cmd.push("yum -y install rsyslog")
    cmd.push("chkconfig rsyslog on")
    cmd.push("service ryslog start")
  end
  return cmd
end

def verify_postinstall(cmd,os_type)
  puts
  puts "You will be presented with the existing entries"
  puts "You can select y, no, or simply hit enter to accept"
  puts
  cmd.each_with_index do |line, index|
    puts line
    puts "[ y/Y/n/N/yes/no ]"
    print "  "
    answer=gets.chomp
    if answer == "n" or answer == "N" or answer == "no"
      cmd[index]="#"+cmd[index]
    end
    if answer == "" or answer == "y" or answer == "Y" or answer == "yes"
      cmd[index]=answer 
    end
  end
  return cmd
end


def output_postinstall(cmd,output_file)
  if output_file
    file=File.open(output_file, 'a')
  end
  cmd.each do |command|
    if output_file
      output=command+"\n"
      file.write(output)
    else
      puts command 
    end
  end
  if output_file
    file.close
  end
  return
end

def populate_postinstall(cmd,os_type,platform)
  cmd=populate_date(cmd,os_type)
  cmd=populate_environment(cmd,os_type)
  cmd=populate_ruby(cmd,os_type)
  cmd=populate_chef(cmd,os_type)
  cmd=populate_puppet(cmd,os_type)
  cmd=populate_vagrant_keys(cmd,os_type)
  cmd=populate_guest_additions(cmd,os_type,platform)
  cmd=populate_sudoers(cmd,os_type)
  cmd=populate_mdns(cmd,os_type)
  cmd=populate_rsyslog(cmd,os_type)
  cmd=populate_network(cmd,os_type)
  cmd=populate_end(cmd,os_type)
end

def do_postinstall(config_name,output_file,output_type,os_type,base_dir,platform)
  if output_file
    output_file="postinstall.sh"
    if config_name
      output_dir=base_dir+"/"+config_name
      output_file=output_dir+"/"+output_file
      if !Dir.exists?(output_dir)
        Dir.mkdir(output_dir)
      end
    end
    if File.exists?(output_file)
      File.delete(output_file)
    end
  end
  cmd=[]
  cmd=populate_postinstall(cmd,os_type,platform)
  if output_type != "default"
    cmd=verify_postinstall(cmd,os_type)
  end
  output_postinstall(cmd,output_file)
  if output_file
    FileUtils.chmod(0755,output_file)
  end
  return
end
