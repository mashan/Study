require 'thread'
require 'pp'

puts "Run thread."
ts = []
3.times { |j|
  ts << Thread.start {
    5.times { |i|
      puts "thread-" << j.to_s << " : " << i.to_s
      sleep rand * 0.1
    }
  }
}

ts.each {|t| t.join }

puts "Run syncronic thread by mutex sychronize."
m = Mutex.new
ts = []
3.times { |j|
  ts << Thread.start {
    m.synchronize { 
      5.times { |i|
        puts "thread-" << j.to_s << " : " << i.to_s
        sleep rand * 0.1
      }
    }
  }
}
ts.each {|t| t.join }


puts "Run syncronic thread by mutex lock."
ts = []
3.times { |j|
  ts << Thread.start {
    begin
      m.lock
      5.times { |i|
        puts "thread-" << j.to_s << " : " << i.to_s
        sleep rand * 0.1
      }
    ensure
      m.unlock
    end
  }
}
ts.each {|t| t.join }


puts "Run syncronic thread by mutex try_lock."
ts = []
3.times { |j|
  ts << Thread.start {
    locked = false
    begin
      locked = m.try_lock # ロック
      raise "lock failed." << j.to_s unless locked
      5.times { |i|
        puts "thread-" << j.to_s << " : " << i.to_s
        sleep rand * 0.1
      }
    ensure
      m.unlock if locked # ロック解除
    end
  }
}

ts.each {|t|
  begin
    t.join
  rescue
    puts $!
  end
}
