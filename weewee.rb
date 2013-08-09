#!/usr/bin/env ruby

# Name:         weewee (Wrapper Extension Engine for veewee)
# Version:      0.0.2
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

# Create a structure to store kickstart/jumpstart information
# Type determines whether it's output to the config or is used by another object

Cfg=Struct.new(:type, :question, :parameter, :value, :eval)
Dfn=Struct.new(:question, :value)

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

def print_usage()
  puts
  print_version()
  puts
  puts "Usage: "+$0+" -[h|V] -[l|s] -[k|p|d] -D -o [OUTPUT]"
  puts
  puts "-V:          Display version information"
  puts "-h:          Display usage information"
  puts "-k:          Create kickstart file (Also sets OS type to Linux)"
  puts "-l:          Set OS to Linux"
  puts "-p:          Create postinstall file"
  puts "-d:          Create definitions file"
  puts "-D:          Use defaults"
  puts "-o: OUTPUT   Output file"
  puts
end

def get_password_crypt(password)
  possible=[('a'..'z'),('A'..'Z'),(0..9),'.','/'].inject([]) {|s,r| s+Array(r)}
  salt=Array.new(8){possible[rand(possible.size)]}
  password=password.crypt("$1$#{salt}")
  return password
end

begin
  opt=Getopt::Std.getopts("Ddklpso:")
rescue
  print_usage()
  exit
end

if opt["l"]
  os_type="linux"
  puts "OS Type is Linux"
end

if opt["k"] or opt["p"] or opt["d"]
  # Import methods
  if Dir.exists?("./methods")
    file_list=Dir.entries("./methods")
    for file in file_list
      if file =~/rb$/
        puts "Loading ./methods/"+file
        require "./methods/#{file}"
      end
    end
  end
end

if opt["o"]
  output_file=opt["o"]
  if File.exists?(output_file)
    File.delete(output_file)
  end
end

if opt["k"]
  os_type="linux"  
  str=Hash.new
  pkg=[]
  cmd=[]
  str=populate_kickstart_header(str)
  if !opt["D"]
    str=verify_kickstart_header(str)
  end
  pkg=populate_kickstart_packages(pkg)
  if !opt["D"]
    pkg=verify_kickstart_array(pkg)
  end
  cmd=populate_kickstart_post(cmd)
  if !opt["D"]
    cmd=verify_kickstart_array(cmd)
  end
  output_kickstart_header(str,output_file)
  output_kickstart_packages(pkg,output_file)
  output_kickstart_post(cmd,output_file)
end

if opt["p"]
  if !opt["l"]
    puts "No OS specified"
    exit
  end
  cmd=[]
  cmd=populate_postinstall(cmd,os_type)
  if !opt["d"]
    cmd=verify_postinstall(cmd,os_type)
  end
  output_postinstall(cmd,output_file)
end

if opt["d"] 
  if !opt["l"]
    puts "No OS specified"
    exit
  end
  str=Hash.new
  str=populate_definition(str,os_type)
  if !opt["D"]
    str=verify_definition(str,os_type)
  end
  output_definition(str,output_file)
end
