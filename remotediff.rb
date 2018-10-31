#!/usr/bin/env ruby
require 'bundler'
Bundler.require


# Argument Parser
opts = Slop::Options.new
opts.banner = "usage: ./remotediff.rb  -l <left_host> -r <right_host> -f <path_to_file>"
opts.separator ""
opts.separator "Mandatory options:"
opts.string '-l', '--left_host', "left host", required: true
opts.string '-r', '--right_host', "right host", required: true
opts.string '-f', '--path_to_file', "path to file to diff. Provide absolute path if not on ssh login home path", required: true
opts.separator ""
opts.on '-h', '--help', 'print help' do
  puts opts
  exit
end
opts.on '-v','--version', 'print the version' do
  puts "keygen v1.0"
  exit
end

parser = Slop::Parser.new(opts)

begin
  options = parser.parse(ARGV)
rescue Slop::Error => e
  puts e.message
  puts opts
  exit
end

left_host    = options[:left_host]
right_host   = options[:right_host]
path_to_file = options[:path_to_file]

#p left_host, right_host, path_to_file

left_result, right_result = ["", ""]
Net::SSH.start( left_host, nil, options= {:config => true , :verbose => :fatal}) do |ssh|
  left_result = ssh.exec!("cat #{path_to_file}")
end
Net::SSH.start( right_host, nil, options= {:config => true , :verbose => :fatal}) do |ssh|
  right_result = ssh.exec!("cat #{path_to_file}")
end


Differ.format = :color
puts "Output"
puts "======"
puts Differ.diff_by_line(left_result, right_result)