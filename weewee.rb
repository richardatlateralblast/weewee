#!/usr/bin/env ruby

# Name:         weewee (Wrapper Extension Engine for veewee)
# Version:      0.0.5
# Release:      1
# License:      Open Source
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: UNIX
# Vendor:       Lateral Blast
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Ruby script to wrapper veewee

require 'getopt/std'
require 'fileutils'
require 'veewee'

default_platform="fusion"
default_linux="CentOS-5.9-x86_64"
default_solaris="solaris-10-ga-x86"
$verbose=1

# Create a structure to store kickstart/jumpstart information
# Type determines whether it's output to the config or is used by another object

Cfg=Struct.new(:type, :question, :parameter, :value, :eval)
Dfn=Struct.new(:question, :value)
Pkg=Struct.new(:name, :install)

def get_version()
  file_array=IO.readlines $0
  version=file_array.grep(/^# Version/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  packager=file_array.grep(/^# Packager/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  name=file_array.grep(/^# Name/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  version=name+" v. "+version+" "+packager
  return version
end

def print_version()
  version=get_version()
  puts version
end

def print_usage(options)
  puts
  print_version()
  puts
  puts "Usage: "+$0+" -["+options+"]"
  puts
  puts "-V: Display version information"
  puts "-h: Display usage information"
  puts "-k: Create kickstart file (Also sets OS type to Linux)"
  puts "-l: Set OS to Linux"
  puts "-s: Set OS to Solaris"
  puts "-r: Remove definition for host"
  puts "-n: Name of new machine to be created"
  puts "-p: Create postinstall file"
  puts "-d: Create definitions file"
  puts "-D: Use defaults"
  puts "-v: Verbose output"
  puts "-f: Output to file rather than STDOUT"
  puts "-L: List Veewee OS types"
  puts "-T: List Veewee Templates"
  puts "-p: Set OS type"
  puts "-O: Set virtualisation platform to Virtual Box"
  puts "-F: Set virtualisation platform to VMware Fusion"
  puts
end

def get_password_crypt(password)
  possible=[('a'..'z'),('A'..'Z'),(0..9),'.','/'].inject([]) {|s,r| s+Array(r)}
  salt=Array.new(8){possible[rand(possible.size)]}
  password=password.crypt("$1$#{salt}")
  return password
end

options="DOdjklpsfvn:o:p:r:L"
# Get command line arguments
# Print help if given none

if !ARGV[0]
  print_usage(options)
  exit
end

begin
  opt=Getopt::Std.getopts(options)
rescue
  print_usage(options)
  exit
end

# Set up base directory

def create_dir(dir_name)
  if !Dir.exists?(dir_name)
    if $verbose == 1
      puts "Creating directory: "+dir_name
    end
    Dir.mkdir(dir_name)
  end
end

base_dir=Dir.home+"/.weewee"
create_dir(base_dir)

def delete_config(config_name,base_dir)
  definition_dir=base_dir+"/definitions/"+config_name
  if Dir.exists?(definition_dir)
    puts "Deleting "+definition_dir 
    FileUtils.rm_r(definition_dir)
  else
    puts "veewee definition for "+config_name+" does not exist in directory "+definition_dir
  end
  return
end

if opt["r"]
  config_name=opt["r"]
  delete_config(config_name,base_dir)
  exit
end

if opt["F"] or opt ["O"]
  if opt ["F"]
    platform="fusion"
  else
    if opt ["O"]
      platform="vbox"
    end
  end
else
  platform=default_platform
end

if opt["L"]
  vcli=Veewee::Environment.new
  vcli.ostypes.each do |key, value|
    if value[:vbox]
      puts value[:vbox]
    end
  end
  exit
end

if opt["T"]
  vcli=Veewee::Environment.new
  template = Veewee::Templates.new(vcli)
  template.each do |key, value|
    puts key
  end
  exit
end

if opt["v"]
  $verbose=1
else
  $verbose=0
end

# If given -l set OS type to Linux

if opt["l"]
  os_type="linux"
  template_name=default_linux
  if opt["v"]
    puts "OS type set to Linux"
  end
end

# If given -s set OS type to Solaris

if opt["s"]
  os_type="solaris"
  template_name=default_solaris
  if opt["v"]
    puts "OS type set to Solaris"
  end
end

if opt["n"]
  if !opt["n"]
    puts "Machine name not specified"
    exit
  end
  box_name=opt["n"]
  system("cd #{base_dir} ; veewee #{platform} define '#{box_name}' '#{template_name}' ")
end

base_dir=base_dir+"/definitions"

create_dir(base_dir)

if opt["f"]
  create_file=1
end

# If OS type is not set handle appropriately
# If -k set to Linux as it's Kickstart
# If -j set to Solaris as it's Jumpstart

if !opt["s"] and !opt["l"]
  if opt["k"]
    os_type="linux"
    puts "Setting OS type to Linux"
  else 
    if opt["j"]
      os_type="solaris"
      puts "Setting OS type to Solaris"
    else
      puts "OS type not selected"
      exit
    end
  end
end

# If given any option that requires methods, load them

if opt["k"] or opt["p"] or opt["d"] or opt["j"] or opt["s"]
  # Import methods
  if Dir.exists?("./methods")
    file_list=Dir.entries("./methods")
    for file in file_list
      if file =~/rb$/
        if opt["v"]
          puts "Loading ./methods/"+file
        end
        require "./methods/#{file}"
      end
    end
  end
end

if opt["D"]
  output_type="default"
  if opt["v"]
    puts "Using defaults"
  end
end

# If given -k and no -s (ie not Solaris) build kickstart file

if opt["k"] and !opt["s"]
  create_file=opt["f"]
  config_name=opt["n"]
  do_kickstart(config_name,create_file,output_type,base_dir)
end

if opt["p"]
  create_file=opt["f"]
  config_name=opt["n"]
  if !opt["l"] and !opt["s"]
    puts "OS type not specified"
    exit
  end
  do_postinstall(config_name,create_file,output_type,os_type,base_dir)
end

if opt["j"] and !opt["l"]
  create_file=opt["f"]
  config_name=opt["n"]
  do_jumpstart(config_name,create_file,output_type,base_dir)
end

if opt["d"] 
  create_file=opt["f"]
  config_name=opt["n"]
  if !opt["l"] and !opt["s"]
    puts "OS type not specified"
    exit
  end
  do_definition(config_name,create_file,output_type,os_type,base_dir)
end
