
def populate_postinstall_definition(str,os_type)
  cfg=Dfn.new(
    question  = "Postinstall Files",
    value     = "[ 'postinstall.sh' ]"
    )
  str["postinstall_files"]=cfg
  cfg=Dfn.new(
    question  = "Postinstall timeout",
    value     = "10000"
    )
  str["postinstall_timeout"]=cfg
  return str
end

def populate_shutdown_definition(str,os_type)
  cfg=Dfn.new(
    question  = "Shutdown command",
    value     = "/sbin/halt -h -p"
    )
  str["shutdown_cmd"]=cfg
  return str
end

def populate_sudo_definition(str,os_type)
  return str
  cfg=Dfn.new(
    question  = "Sudo command",
    value     = "echo '%p'|sudo -S sh '%f'"
    )
  str["sudo_cmd"]=cfg
  return str
end

def populate_system_definition(str,os_type)
  cfg=Dfn.new(
    question  = "Number of CPUs",
    value     = "1"
    )
  str["cpu_count"]=cfg
  if os_type == "linux"
    cfg=Dfn.new(
      question  = "Memory size",
      value     = "384"
      )
  end
  if os_type == "solaris"
    cfg=Dfn.new(
      question  = "Memory size",
      value     = "768"
      )
  end
  str["memory_size"]=cfg
  if os_type == "linux"
    cfg=Dfn.new(
      question  = "Disk size",
      value     = "10140"
      )
  end
  if os_type == "solaris"
    cfg=Dfn.new(
      question  = "Disk size",
      value     = "65140"
      )
  end
  str["disk_size"]=cfg
  cfg=Dfn.new(
    question  = "Disk format",
    value     = "VDI"
    )
  str["disk_format"]=cfg
  cfg=Dfn.new(
    question  = "Host IO cache",
    value     = "off"
    )
  str["hostiocache"]=cfg
  cfg=Dfn.new(
    question  = "IO APIC",
    value     = "on"
    )
  str["ioapic"]=cfg
  cfg=Dfn.new(
    question  = "PAE",
    value     = "on"
    )
  str["pae"]=cfg
  return str
end

def populate_os_definition(str,os_type)
  if os_type == "linux"
    cfg=Dfn.new(
      question  = "OS type ID",
      value     = "RedHat_64"
      )
  end
  if os_type == "solaris"
    cfg=Dfn.new(
      question  = "OS type ID",
      value     = "Solaris_64"
      )
  end
  str["os_type_id"]=cfg
  return str
end

def populate_boot_definition(str,os_type)
  cfg=Dfn.new(
    question  = "Boot wait",
    value     = "10"
    )
  str["boot_wait"]=cfg
  return str
end

def populate_iso_definition(str,os_type)
  if os_type == "linux"
    cfg=Dfn.new(
      question  = "ISO File",
      value     = "CentOS-5.9-x86_64-bin-DVD-1of2.iso"
      )
  end
  if os_type == "solaris"
    cfg=Dfn.new(
      question  = "ISO File",
      value     = "sol-10-u11-ga-x86-dvd.iso"
      )
  end
  str["iso_src"]=cfg
  cfg=Dfn.new(
    question  = "ISO MD5",
    value     = ""
    )
  str["iso_md5"]=cfg
  cfg=Dfn.new(
    question  = "ISO download timeout",
    value     = "10000"
    )
  str["iso_download_timeout"]=cfg
  return str
end

def populate_linux_definition(str,os_type)
  if os_type == "linux"
    cfg=Dfn.new(
      question  = "Boot command sequence",
      value     = "[ 'linux text ks=http://%IP%:%PORT%/ks.cfg<Enter>' ]"
      )
  end
  if os_type == "solaris"
    cfg=Dfn.new(
      question  = "Boot command sequence",
      value     = "[ 'e', 'e', '<Backspace>'*22, '- nowin install -B install_media=cdrom<Enter>', 'b', ]" 
      )
  end
  str["boot_cmd_sequence"]=cfg
  if os_type == "solaris"
    cfg=Dfn.new(
      question  = "Floppy files",
      value     = "[ 'jumpstart/sysidcfg', 'jumpstart/rules', 'jumpstart/rules.ok',
                     'jumpstart/begin', 'jumpstart/profile', 'jumpstart/finish' ]"
      )
    str["floppy_file"]=cfg
  end
  cfg=Dfn.new(
    question  = "Kickstart port",
    value     = "7122"
    )
  str["kickstart_port"]=cfg
  cfg=Dfn.new(
    question  = "Kickstart timeout",
    value     = "10000"
    )
  str["kickstart_timeout"]=cfg
  cfg=Dfn.new(
    question  = "Kickstart file",
    value     = "ks.cfg"
    )
  str["kickstart_file"]=cfg
  return str
end

def populate_ssh_definition(str,os_type)
  cfg=Dfn.new(
    question  = "SSH login timeout",
    value     = "10000"
    )
  str["ssh_login_timeout"]=cfg
  cfg=Dfn.new(
    question  = "SSH user",
    value     = "vagrant"
    )
  str["ssh_user"]=cfg
  cfg=Dfn.new(
    question  = "SSH password",
    value     = "vagrant"
    )
  str["ssh_password"]=cfg
  cfg=Dfn.new(
    question  = "SSH Key",
    value     = ""
    )
  str["ssh_key"]=cfg
  cfg=Dfn.new(
    question  = "SSH Host port",
    value     = "7222"
    )
  str["ssh_host_port"]=cfg
  cfg=Dfn.new(
    question  = "SSH guest port",
    value     = "22"
    )
  str["ssh_guest_port"]=cfg
  return str
end

def output_definition(str,output_file)
  output="Veewee::Session.declare({\n"
  if output_file
    file=File.open(output_file, 'a')
    file.write(output)
  else
    print output 
  end 
  str.each do |key, value|
    if key == "postinstall_timeout"
      output="  :"+key+" => \""+str[key].value+"\"\n"
    else
      output="  :"+key+" => \""+str[key].value+"\",\n"
    end
    if output_file
      file.write(output)
    else
      print output 
    end
  end
  if output_file
    output="})"
    file.write(output)
    file.close
  else
    puts "})"
  end
  return
end

def verify_definition(str,os_type)
  puts
  puts "You will be presented with a set of questions followed by the default output"
  puts "If you are happy with the default output simply hit enter"
  puts
  str.each do |key, value|
    puts str[key].question+"?"
    puts "[ "+str[key].value+" ]"
    print "  "
    answer=gets.chomp
    if answer != ""
      if answer != str[key].value
        str[key].value=answer 
      end
    end
  end
  return str
end

def do_definition(config_name,output_file,output_type,os_type)
  if output_file
    output_file="definition.rb"
    if config_name
      output_dir=$base_dir+"/"+config_name
      output_file=output_dir+"/"+output_file
      if !Dir.exists?(output_dir)
        Dir.mkdir(output_dir)
      end
    end
    if File.exists?(output_file)
      File.delete(output_file)
    end
  end
  str=Hash.new
  str=populate_definition(str,os_type)
  if output_type != "default"
    str=verify_definition(str,os_type)
  end
  output_definition(str,output_file)
  if output_file
    FileUtils.chmod(0755,output_file)
  end
end

def populate_definition(str,os_type)
  str=populate_system_definition(str,os_type)
  str=populate_os_definition(str,os_type)
  str=populate_boot_definition(str,os_type)
  str=populate_iso_definition(str,os_type)
  if os_type == "linux"
    str=populate_linux_definition(str,os_type)
  end
  str=populate_ssh_definition(str,os_type)
  str=populate_sudo_definition(str,os_type)
  str=populate_shutdown_definition(str,os_type)
  str=populate_postinstall_definition(str,os_type)
  return str
end
