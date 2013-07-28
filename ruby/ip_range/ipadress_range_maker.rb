#!/usr/bin/ruby
require 'ipaddr'
require 'pp'

ALLOWED_SKIP_IP_COUNT = 10

def guess_ip_subnet(ip_log_sum, hosts_num)
  ipaddr = IPAddr.new(ip_log_sum, Socket::AF_INET).to_s
  # +2 => network & broadcast
  prefix = ( 32 - ( Math.log( hosts_num + 2) / Math.log(2) ).ceil )
  IPAddr.new("#{ipaddr}/#{prefix}")
end


# TODO:IPアドレスのリストを取得
ip_lists = [
#  "10.0.2.1",
#  "10.2.1.1",
#  "10.3.1.4",
#
#  "172.10.0.1",
#  "172.10.0.2",
#  "172.10.0.3",
#  "172.10.0.10",
#
  "192.168.1.1",
  "192.168.1.2",
  "192.168.1.3",
#  "192.168.1.5",
#  "192.168.1.10",
#  "192.168.1.15",
  "192.168.1.26",
]

# IPが連続していく場合と分ける場合で分けて処理
## 連続する場合 => レンジを広げていく
## 切れた場合 => 今まで保存していたリストを使ってリストを作成

ip_logicalsum_hosts_nums = Hash.new
ip_range_lists = Array.new

ip_before      = nil
ip_current     = nil
ip_logical_sum = 0
hosts_num      = 0

ip_lists.each do |ip|
  puts ip
  ip_current = IPAddr.new(ip)

  regard_same_network_range = Range.new( ip_before.to_i, ip_before.to_i + ALLOWED_SKIP_IP_COUNT )
  if ip_before && regard_same_network_range.include?(ip_current.to_i )
    ip_logical_sum = ip_logical_sum & ip_current.to_i
    hosts_num += ip_current.to_i - ip_before.to_i
  else
    ip_logical_sum = ip_current.to_i
    ip_before = nil
    hosts_num = 1
  end

  pp ip_logical_sum
  pp hosts_num
  ip_logicalsum_hosts_nums[ip_logical_sum] = hosts_num
  ip_before = ip_current
end

ip_logicalsum_hosts_nums.each do | ip_log_sum, hosts_num|
  ip_range_lists << guess_ip_subnet(ip_log_sum, hosts_num)
end

# 作成されたリストを出力
pp ip_range_lists
