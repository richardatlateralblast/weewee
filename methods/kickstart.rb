
def get_kickstart_language(str)
  result="--default="+str["install_language"].value+" "+str["install_language"].value
  return result
end

def get_kickstart_xconfig(str)
  result="--card "+str["videocard"].value+" --videoram "+str["videoram"].value+" --hsync "+str["hsync"].value+" --vsync "+str["vsync"].value+" --resolution "+str["resolution"].value+" --depth "+str["depth"].value
  return result
end

def get_kickstart_network(str)
  result="--device "+str["nic"].value+" --bootproto "+str["bootproto"].value
  return result
end

def get_kickstart_password(str)
  result="--iscrypted "+str["crypt"].value
  return result
end

def get_kickstart_bootloader(str)
  result="--location="+str["bootstrap"].value
  return result
end

def get_kickstart_clearpart(str)
  result="--all --drives="+str["bootdevice"].value+" --initlabel"
  return result
end

def get_kickstart_bootpart(str)
  result=str["bootmount"].value+" --fstype "+str["bootfs"].value+" --size="+str["bootsize"].value+" --ondisk="+str["bootdevice"].value
  return result
end

def get_kickstart_volpart(str)
  result=str["volname"].value+" --size="+str["volsize"].value+" --grow --ondisk="+str["bootdevice"].value
  return result
end

def get_kickstart_volgroup(str)
  result=str["volgroupname"].value+" --pesize="+str["pesize"].value+" "+str["volname"].value
  return result
end

def get_kickstart_logswap(str)
  result="swap --fstype swap --name="+str["swapvol"].value+" --vgname="+str["volgroupname"].value+" --size="+str["swapmin"].value+" --grow --maxsize="+str["swapmax"].value
  return result
end

def get_kickstart_logroot(str)
  result="/ --fstype "+str["rootfs"].value+" --name="+str["rootvol"].value+" --vgname="+str["volgroupname"].value+" --size="+str["rootsize"].value+" --grow"
  return result
end

def populate_kickstart_header(str)
  version=get_version()
  cfg=Cfg.new(
    type      = "output",
    question  = "Kickstart file header comment",
    parameter = "",
    value     = "# "+version,
    eval      = "no"
    )
  str["kickstart_header"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Install type",
    parameter = "",
    value     = "install",
    eval      = "no"
    )
  str["install_type"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Install Medium",
    parameter = "",
    value     = "cdrom",
    eval      = "no"
    )
  str["install_method"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Install Language",
    parameter = "lang",
    value     = "en_US.UTF-8",
    eval      = "no"
    )
  str["install_language"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Support Language",
    parameter = "langsupport",
    value     = get_kickstart_language(str),
    eval      = "get_kickstart_language(str)"
    )
  str["support_language"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Keyboard",
    parameter = "keyboard",
    value     = "us",
    eval      = "no"
    )
  str["keyboard"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Video Card",
    parameter = "",
    value     = "VMWare",
    eval      = "no"
    )
  str["videocard"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Video RAM",
    parameter = "",
    value     = "16384",
    eval      = "no"
    )
  str["videoram"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Horizontal Sync",
    parameter = "",
    value     = "31.5-37.9",
    eval      = "no"
    )
  str["hsync"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Vertical Sync",
    parameter = "",
    value     = "50-70",
    eval      = "no"
    )
  str["vsync"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Resolution",
    parameter = "",
    value     = "800x600",
    eval      = "no"
    )
  str["resolution"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Bit Depth",
    parameter = "",
    value     = "16",
    eval      = "no"
    )
  str["depth"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Xconfig",
    parameter = "xconfig",
    value     = get_kickstart_xconfig(str),
    eval      = "get_kickstart_xconfig(str)"
    )
  str["xconfig"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Primary Network Interface",
    parameter = "",
    value     = "eth0",
    eval      = "no"
    )
  str["nic"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Boot Protocol",
    parameter = "",
    value     = "dhcp",
    eval      = "no"
    )
  str["bootproto"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Network Configuration",
    parameter = "network",
    value     = get_kickstart_network(str),
    eval      = "get_kickstart_network(str)"
    )
  str["network"]=cfg
  password="sun123"
  cfg=Cfg.new(
    type      = "",
    question  = "Root Password",
    parameter = "",
    value     = password,
    eval      = "no"
    )
  str["password"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Root Password Crypt",
    parameter = "",
    value     = get_password_crypt(password),
    eval      = "get_password_crypt(password)"
    )
  str["crypt"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Root Password Configuration",
    parameter = "rootpw",
    value     = get_kickstart_password(str),
    eval      = "get_kickstart_password(str)"
    )
  str["bootproto"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Root Password Configuration",
    parameter = "rootpw",
    value     = get_kickstart_password(str),
    eval      = "get_kickstart_password(str)"
    )
  str["bootproto"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "SELinux Configuration",
    parameter = "selinux",
    value     = "--enforcing",
    eval      = "no"
    )
  str["selinux"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "SELinux Configuration",
    parameter = "authconfig",
    value     = "--enableshadow --enablemd5",
    eval      = "no"
    )
  str["authconfig"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Timezone",
    parameter = "timezone",
    value     = "Australia/Melbourne",
    eval      = "no"
    )
  str["timezone"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Bootstrap",
    parameter = "",
    value     = "mbr",
    eval      = "no"
    )
  str["bootstrap"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Bootloader",
    parameter = "bootloader",
    value     = get_kickstart_bootloader(str), 
    eval      = "get_kickstart_bootloader(str)"
    )
  str["bootloader"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Boot Device",
    parameter = "",
    value     = "sda",
    eval      = "no"
    )
  str["bootdevice"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Clear Parition",
    parameter = "clearpart",
    value     = get_kickstart_clearpart(str), 
    eval      = "get_kickstart_clearpart(str)"
    )
  str["clearpart"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Boot Mount Point",
    parameter = "",
    value     = "/boot",
    eval      = "no"
    )
  str["bootmount"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Boot Filesystem",
    parameter = "",
    value     = "ext3",
    eval      = "no"
    )
  str["bootfs"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Boot Size",
    parameter = "",
    value     = "100",
    eval      = "no"
    )
  str["bootsize"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Clear Parition",
    parameter = "part",
    value     = get_kickstart_bootpart(str), 
    eval      = "get_kickstart_bootpart(str)"
    )
  str["bootpart"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Physical Volume Name",
    parameter = "",
    value     = "pv.2",
    eval      = "no"
    )
  str["volname"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Physical Volume Size",
    parameter = "",
    value     = "0",
    eval      = "no"
    )
  str["volsize"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Physical Volume Configuration",
    parameter = "part",
    value     = get_kickstart_volpart(str), 
    eval      = "get_kickstart_volpart(str)"
    )
  str["volpart"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Volume Group Name",
    parameter = "",
    value     = "VolGroup00",
    eval      = "no"
    )
  str["volgroupname"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Physical Extent Size",
    parameter = "",
    value     = "32768",
    eval      = "no"
    )
  str["pesize"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Volume Group Configuration",
    parameter = "volgroup",
    value     = get_kickstart_volgroup(str), 
    eval      = "get_kickstart_volgroup(str)"
    )
  str["volgroup"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Minimum Swap Size",
    parameter = "",
    value     = "512",
    eval      = "no"
    )
  str["swapmin"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Maximum Swap Size",
    parameter = "",
    value     = "1024",
    eval      = "no"
    )
  str["swapmax"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Swap Volume Name",
    parameter = "",
    value     = "LogVol01",
    eval      = "no"
    )
  str["swapvol"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Swap Logical Volume Configuration",
    parameter = "logvol",
    value     = get_kickstart_logswap(str), 
    eval      = "get_kickstart_logswap(str)"
    )
  str["logswap"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Root Filesystem",
    parameter = "",
    value     = "ext3",
    eval      = "no"
    )
  str["rootfs"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Root Volume Name",
    parameter = "",
    value     = "LogVol00",
    eval      = "no"
    )
  str["rootvol"]=cfg
  cfg=Cfg.new(
    type      = "",
    question  = "Root Size",
    parameter = "",
    value     = "1024",
    eval      = "no"
    )
  str["rootsize"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Root Logical Volume Configuration",
    parameter = "logvol",
    value     = get_kickstart_logroot(str), 
    eval      = "get_kickstart_logroot(str)"
    )
  str["logroot"]=cfg
  cfg=Cfg.new(
    type      = "output",
    question  = "Finish Command",
    parameter = "",
    value     = "reboot",
    eval      = "no"
    )
  str["finish"]=cfg
  return str
end

def output_kickstart_header(str,output_file)
  if output_file
    file=File.open(output_file, 'a')
  end 
  str.each do |key, value|
    if str[key].type == "output"
      if str[key].parameter == ""
        if output_file
          output=str[key].value+"\n"
          file.write(output)
        else
          puts str[key].value
        end
      else
        if output_file
          output=str[key].parameter+" "+str[key].value+"\n"
          file.write(output)
        else
          puts str[key].parameter+" "+str[key].value
        end
      end
    end
  end
  if output_file
    file.close
  end
  return
end

def verify_kickstart_header(str)
  puts
  puts "You will be presented with a set of questions followed by the default output"
  puts "If you are happy with the default output simply hit enter"
  puts
  change=0
  str.each do |key, value|
    if change == 1
      if str[key].eval != "no"
        new_value=str[key].eval
        new_value=eval"[#{new_value}]"
        str[key].value=new_value
      end
    end
    puts str[key].question+"?"
    puts "[ "+str[key].value+" ]"
    print "  "
    answer=gets.chomp
    if answer != ""
      if answer != str[key].value
        change=1
        str[key].value=answer 
      end
    end
  end
  return
end

def verify_kickstart_array(array)
  puts
  puts "You will be presented with the existing entries"
  puts
  array.each_with_index do |line, index|
    puts line
    puts "[ y/Y/n/N/yes|no ]"
    print "  "
    answer=gets.chomp
    if answer == "n" or answer == "N" or answer == "no"
      array[index]="#"+array[index]
    end
    if answer == "" or answer == "y" or answer == "Y" or answer == "yes"
      array[index]=answer 
    end
  end
  return array
end

def populate_kickstart_packages(pkg)
  pkg.push("@ core")
  pkg.push("grub")
  pkg.push("e2fsprogs")
  pkg.push("lvm2")
  pkg.push("kernel-devel")
  pkg.push("kernel-headers")
  return pkg
end

def output_kickstart_packages(pkg,output_file)
  if output_file
    file=File.open(output_file, 'a')
    output="\n%packages\n"
    file.write(output)
  else
    puts
    puts "%packages"
  end
  pkg.each do |pkg_name|
    if output_file
      output=pkg_name+"\n"
      file.write(output)
    else  
      puts pkg_name
    end
  end
  if output_file
    file.close
  end
  return
end

def populate_kickstart_post_vagrant_commands(cmd)
  cmd.push("/usr/sbin/groupadd vagrant")
  cmd.push("/usr/sbin/useradd vagrant -g vagrant -G wheel")
  cmd.push("echo \"vagrant\"|passwd --stdin vagrant")
  cmd.push("echo \"vagrant        ALL=(ALL)       NOPASSWD: ALL\" >> /etc/sudoers")
  return cmd
end

def populate_kickstart_post(cmd)
  cmd=populate_kickstart_post_vagrant_commands(cmd)
  return cmd
end

def output_kickstart_post(cmd,output_file)
  if output_file
    file=File.open(output_file, 'a')
    output="\n%post\n"
    file.write(output)
  else
    puts
    puts "%post"
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
