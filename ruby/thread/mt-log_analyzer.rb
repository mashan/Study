require 'thwait'
require 'pp'
NUM_THREADS = 2

files = [
  './sample/access.1.log',
  './sample/access.2.log',
  './sample/access.3.log',
]

queue = Queue.new
files.each do |file|
  queue.push(file)
end

threads = []

NUM_THREADS.times do 
  queue.push(nil)
  thread = Thread.new do 
    counts = {}
    while file = queue.pop
      File.readlines(file).map do |line|
        line.chomp!
        if counts.key?(line)
          counts[line] += 1
        else
          counts[line] = 1
        end
      end
    end
    counts
  end
  threads.push(thread)
end

tw = ThreadsWait.new(*threads)
results = {}

while !tw.empty? do
  th = tw.next_wait
  th.value.each do | key, value |
    if results.key?(key)
      results[key] += value
    else
      results[key] = value
    end
  end
end

pp results
