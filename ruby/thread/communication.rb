require 'thread'

q = Queue.new

workers = []
3.times { |j|
  workers << Thread.start {
    name = 'thread-' << j.to_s
    loop {
      q.pop.call( name ) 
      sleep rand * 0.1
    }
  }
}

makers = []
3.times { |j|
  makers << Thread.start {
    5.times { |i|
      q.push Proc.new { |name|
        puts name + " : " + i.to_s
      }
      sleep rand * 0.1
    }
  }
}

sleep 3
