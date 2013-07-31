#!/usr/bin/ruby
require 'ipaddr'
require 'pp'

ALLOWED_SKIP_IP_COUNT = 10

def guess_ip_range(ip_log_sum, hosts_num)
  ipaddr = IPAddr.new(ip_log_sum, Socket::AF_INET).to_s
  # +2 => network & broadcast
  prefix = ( 32 - ( Math.log( hosts_num + 2) / Math.log(2) ).ceil )
  IPAddr.new("#{ipaddr}/#{prefix}")
end

samples = [
  "10.0.2.1",
  "10.2.1.1",
  "10.3.1.4",

  "172.10.0.1",
  "172.10.0.2",
  "172.10.0.3",
  "172.10.0.10",

  "192.168.1.1",
  "192.168.1.2",
  "192.168.1.3",
  "192.168.1.5",
  "192.168.1.10",
  "192.168.1.15",
  "192.168.2.255",
]

hosts_nums = Hash.new
ip_range_lists = Array.new
ip_lists = Array.new

ip_before      = nil
ip_logical_sum = 0
hosts_num      = 0

samples.each do |ip|
  ip_current = IPAddr.new(ip)
  ip_lists << ip_current

  if ! ip_before
    ip_logical_sum = ip_current.to_i
    ip_before = ip_current
    hosts_num = 1
    next
  end

  regard_same_network_range = Range.new( ip_before.to_i, ip_before.to_i + ALLOWED_SKIP_IP_COUNT )
  if regard_same_network_range.include?(ip_current.to_i )
    ip_logical_sum = ip_logical_sum & ip_current.to_i
    hosts_num += ip_current.to_i - ip_before.to_i
    ip_before = ip_current
    ip_lists.delete(ip_current)
    next
  end

  hosts_nums[ip_logical_sum] = hosts_num
  ip_before = nil
  ip_logical_sum = 0
  hosts_num = 1
end

hosts_nums.each do | ip_log_sum, hosts_num|
  ip_range_lists << guess_ip_range(ip_log_sum, hosts_num)
end

ip_lists.each do |ip|
  is_include = false
  ip_range_lists.each do |range|
    is_include = true if range.include?(ip)
  end

  unless is_include
    ip_range_lists << ip
  end
end

pp ip_range_lists
