def multi_process(ary)
  threads = []

  # aryの数だけthreadができるので遅くなる可能性が高い
  ary.each_with_index do |e, i|
    threads << Thread.start(e, i) do |tle, tli| 
      yield(tle, tli) 
    end
  end

  threads.each{|t| t.join }
end
 
a = [1, 2, 3]
multi_process(a) do |item, index|
  sleep 0.1 * rand(10)
  puts "[#{index}]" + (item * 2).to_s
end
