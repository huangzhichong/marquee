# run with: god -c /path/to/xxxx.god -D
# 
# This is the actual config file used to keep marquee server running.

FARM_SERVER_ROOT = "~/marquee_reload/marquee-web-main/farm_reload/server"

God.watch do |w|
  w.name = "server"
  w.interval = 30.seconds # default
  w.start = "cd #{FARM_SERVER_ROOT}; ruby server_control.rb start"
  w.stop = "cd #{FARM_SERVER_ROOT}; ruby server_control.rb stop"
  w.restart = "cd #{FARM_SERVER_ROOT}; ruby server_control.rb restart"
  w.start_grace = 30.seconds
  w.restart_grace = 30.seconds
  w.pid_file = "#{FARM_SERVER_ROOT}/server.rb.pid"
  
  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 30.seconds
      c.running = false
    end
  end
  
  # w.restart_if do |restart|
  #   restart.condition(:http_response_code) do |c|
  #    c.host = 'localhost'
  #    c.port = 3000
  #    c.path = '/'
  #    c.timeout = 10.seconds
  #    c.times = [4, 5]
  #    c.code_is_not = 200
  #  end
  
  #  # restart.condition(:memory_usage) do |c|
  #  #   c.above = 150.megabytes
  #  #   c.times = [3, 5] # 3 out of 5 intervals
  #  # end
  
  #  # restart.condition(:cpu_usage) do |c|
  #  #   c.above = 50.percent
  #  #   c.times = 5
  #  # end
  # end
  
  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end