
def populate_date(cmd,os_type)
  cmd.push("")
  cmd.push("date > /etc/vagrant_box_build_time")
  return cmd
end

def populate_vbox(cmd,os_type)
  cmd.push("")
  if os_type == "linux"
    cmd.push("#kernel source is needed for vbox additions")
    cmd.push("yum -y install gcc bzip2 make kernel-devel-`uname -r`")
    cmd.push("yum -y install gcc-c++ zlib-devel openssl-devel readline-devel sqlite3-devel")
    cmd.push("yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts")
    cmd.push("yum -y clean all")
  end
  return cmd
end

def populate_ruby(cmd,os_type)
  cmd.push("")
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
  return cmd
end

def populate_chef(cmd,os_type)
  cmd.push("")
  cmd.push("echo 'Installing chef'")
  cmd.push("/usr/local/bin/gem install chef --no-ri --no-rdoc")
  return cmd
end

def populate_puppet(cmd,os_type)
  cmd.push("")
  cmd.push("echo 'Installing puppet'")
  cmd.push("/usr/local/bin/gem install puppet --no-ri --no-rdoc")
  return cmd
end

def populate_vagrant_keys(cmd,os_type)
  cmd.push("")
  cmd.push("#Installing vagrant keys")
  cmd.push("mkdir /home/vagrant/.ssh")
  cmd.push("chmod 700 /home/vagrant/.ssh")
  cmd.push("cd /home/vagrant/.ssh")
  cmd.push("wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys")
  cmd.push("chown -R vagrant /home/vagrant/.ssh")
  return cmd
end

def populate_guest_additions(cmd,os_type)
  cmd.push("")
  cmd.push("#Installing the virtualbox guest additions")
  cmd.push("VBOX_VERSION=$(cat /home/vagrant/.vbox_version)")
  cmd.push("cd /tmp")
  cmd.push("wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso")
  cmd.push("mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt")
  cmd.push("sh /mnt/VBoxLinuxAdditions.run")
  cmd.push("umount /mnt")
  cmd.push("rm VBoxGuestAdditions_$VBOX_VERSION.iso")
  return cmd
end

def populate_sudoers(cmd,os_type)
  cmd.push("")
  cmd.push("#Sudoers")
  cmd.push("sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers")
  cmd.push("sed -i 's/^\(.*env_keep = \"\)/\1PATH /' /etc/sudoers")
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

def populate_postinstall(cmd,os_type)
  cmd=populate_date(cmd,os_type)
  cmd=populate_vbox(cmd,os_type)
  cmd=populate_ruby(cmd,os_type)
  cmd=populate_chef(cmd,os_type)
  cmd=populate_puppet(cmd,os_type)
  cmd=populate_vagrant_keys(cmd,os_type)
  cmd=populate_guest_additions(cmd,os_type)
  cmd=populate_sudoers(cmd,os_type)
  cmd=populate_mdns(cmd,os_type)
  cmd=populate_rsyslog(cmd,os_type)
end

