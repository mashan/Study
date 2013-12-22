require 'rubygems'
require 'parallel'
require 'open-uri'
require 'digest/md5'

urls = [
    'http://farm4.staticflickr.com/3052/3086132328_e2041be795.jpg',
    'http://farm7.staticflickr.com/6053/6312937936_cebaf2feb9.jpg',
    'http://farm1.staticflickr.com/54/131841577_0e67642c02.jpg',
    'http://farm3.staticflickr.com/2293/2266151759_058e732577.jpg'
]

Parallel.each(urls, in_threads: 2) {|url|
  puts "start download: #{url}"
  img = open(image) rescue next
  img.close
  file_path = "./#{Digest::MD5.hexdigest(url)}.jpg"
  File.rename(img.path, file_path)
  puts "end download: #{url}"
}

