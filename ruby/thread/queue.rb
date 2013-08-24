require 'thread'

q = Queue.new

# ワーカースレッド
workers = []
3.times do |j|
  workers << Thread.start do
    name = 'thread-' << j.to_s
    loop {
      # queueからタスクを取り出して実行している
      q.pop.call( name ) 
      sleep rand * 0.1
    }
  end
end

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
