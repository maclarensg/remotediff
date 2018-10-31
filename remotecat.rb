#!/usr/bin/env ruby
require 'bundler'
Bundler.require


# Argument Parser
opts = Slop::Options.new
opts.banner = "usage: ./remotediff.rb  -h <remote_host> -f <path_to_file>"
opts.separator ""
opts.separator "Mandatory options:"
opts.string '-H', '--host', "remote host", required: true
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

host    = options[:host]
path_to_file = options[:path_to_file]


result = ""
Net::SSH.start( host, nil, options= {:config => true , :verbose => :fatal}) do |ssh|
  result = ssh.exec!("cat #{path_to_file}")
end

puts "Output"
puts "======"
puts result