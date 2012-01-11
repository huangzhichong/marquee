require "rubygems"
require "eventmachine"
require "#{File.dirname(__FILE__)}/client_conn"

module Marquee
  class Client
    def start
      trap('INT'){EventMachine.stop}
      trap('TERM'){EventMachine.stop}

      EventMachine.run do
        EventMachine.connect('marquee.dev.activenetwork.com', 9527, ClientConn) do |conn|
          puts 'Client#connect'
        end
      end
    end

  end
end

Marquee::Client.new.start
