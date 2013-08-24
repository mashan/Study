require 'open-uri'
require 'nokogiri'
require 'thwait'
require 'pp'

queue = [
  'http://hitode909.hatenablog.com',
  'http://mashan.hatenablog.com/',
  'http://hatenablog.com',
]

threads = []

queue.each do |url|
  threads << Thread.new {
    (Nokogiri open url).at('title').content
  }
end

tw = ThreadsWait.new(*threads)
# 最初に終了したスレッドの値を表示

while ! tw.empty? do
  th = tw.next_wait
  puts th.value
end
