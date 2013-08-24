# スレッド数の上限を設定
thread_max = 3

# queueを作成
jobqueue = Queue.new
(1..10).each do |n|
  jobqueue.push(n)
end

threads = []
thread_max.times do
  threads << Thread.start do
    while !jobqueue.empty?
      var = jobqueue.pop
      ActiveRecord::Base.connection_pool.with_connection do
        puts "#{var}番目 #{User.find(var).id}"
        sleep 10 - var
      end
    end
  end
end

# スレッド完了待ち
threads.each {|t| t.join}

puts "finish!!" 
