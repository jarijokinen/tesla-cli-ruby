require 'io/console'
require 'pp'
require 'thor'
require 'tesla/auth'
require 'tesla/vehicle'

module Tesla
  class Cli < Thor
    desc 'login', 'Log in to your Tesla Account'
    def login
      print 'Email: '
      email = STDIN.gets.chomp

      print 'Password: '
      password = STDIN.noecho(&:gets).chomp

      auth = Auth.new
      auth.login(email, password) unless auth.logged_in?
    end

    desc 'raw', 'Show vehicle information in raw format'
    def raw
      v = Vehicle.new
      pp v.info
    end
    
    desc 'temp', 'Show temperature information'
    def temp
      v = Vehicle.new
      puts <<~EOF
        Current
          Inside:    #{v.inside_temp}
          Outside:   #{v.outside_temp}
        Settings
          Driver:    #{v.driver_temp_setting}
          Passenger: #{v.passenger_temp_setting}
      EOF
    end
  end
end
