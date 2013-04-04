require 'daemon_spawn'

class MyDaemon < DaemonSpawn::Base
  def start(args)
    puts "start : #{Time.now}"
#    i = 0
#    loop do
#        i += 1
#    end
  end

  def stop
    puts "stop  : #{Time.now}"

    # やることがなくても、メソッドを実装しないと例外
  end
end

MyDaemon.spawn!({
    :working_dir => './', # これだけ必須オプション
    :pid_file => './tmp/tmp.pid',
    :log_file => './log/tmp.log',
    :sync_log => true,
    :singleton => true 
  })

