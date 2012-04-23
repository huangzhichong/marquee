# run with: god -c /path/to/xxxx.god -D
# 
# This is the actual config file used to keep marquee resque job running.

rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/home/activeworks/marquee/marquee-web-main"

["marquee_farm","marquee_mailer","marquee_data_sync"].each do |name|
  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.name     = "resque-#{name}-watcher"
    w.group    = 'resque'
    w.interval = 60.seconds
    w.env      = {"QUEUE"=>name, 'PIDFILE' => "#{rails_root}/tmp/pids/#{name}.pid"}
    w.start    = "cd #{rails_root}/ && rake environment resque:work QUEUE=#{name}"
    w.start_grace   = 60.seconds
    w.log      = "#{rails_root}/log/god-resque-#{name}.log"

    # w.uid = 'activeworks'
    # w.gid = 'activeworks'

    God::Contacts::Email.defaults do |d|
      d.from_email = 'marquee@active.com'
      d.from_name = 'Marquee nginx monitoring'
      d.delivery_method = :smtp
      d.server_host = 'mx1.dev.activenetwork.com'
      d.server_port = 25
    end

    God.contact(:email) do |c|
      c.name = 'Eric Yang'
      c.group = 'Marquee Team'
      c.to_email = 'eric.yang@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Tyrael Tong'
      c.group = 'Marquee Team'
      c.to_email = 'tyrael.tong@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Smart Huang'
      c.group = 'Marquee Team'
      c.to_email = 'smart.huang@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Leo Yin'
      c.group = 'Marquee Team'
      c.to_email = 'Leo.Yin@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Shawn Xu'
      c.group = 'Marquee Team'
      c.to_email = 'Shawn.Xu@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Brent Huang'
      c.group = 'Marquee Team'
      c.to_email = 'Brent.Huang@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Lynn Wang'
      c.group = 'Marquee Team'
      c.to_email = 'Lynnw.Wang@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Emma Wang'
      c.group = 'Marquee Team'
      c.to_email = 'Emma.Wang@activenetwork.com'
    end

    God.contact(:email) do |c|
      c.name = 'Sydney Zhang'
      c.group = 'Marquee Team'
      c.to_email = 'Sydney.Zhang@activenetwork.com'
    end

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 60.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 60.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end