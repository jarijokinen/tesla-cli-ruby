require 'httparty'
require 'tesla/auth'

module Tesla
  class Vehicle
    def initialize(id = nil)
      @baseurl = 'https://owner-api.teslamotors.com/api/1/vehicles'
      @info = Hash.new

      auth = Auth.new
      unless auth.logged_in?
        puts 'Please log in first'
        exit -1
      end

      @headers = {
        'Authorization': "Bearer #{auth.access_token}",
        'User-Agent': 'tesla-cli-ruby'
      }

      if id
        @id = id.to_s
      elsif auth.default_vehicle
        @id = auth.default_vehicle.to_s
      else
        @id = first['id'].to_s
        teslarc = JSON.parse(File.read(File.join(ENV['HOME'], '.teslarc')))
        teslarc['default_vehicle'] = @id
        File.write(File.join(ENV['HOME'], '.teslarc'), teslarc.to_json)
      end
      
      fetch
    end

    def fetch
      url = File.join(@baseurl, @id, 'vehicle_data')
      res = HTTParty.get(url, headers: @headers)
      
      if res.include?('error') && res['error'].include?('vehicle unavailable')
        puts 'Vehicle unavailable, trying to wake up...'
        wake_up!
        exit -1
      end

      @info = res['response']
    end
    
    def command_success?(res)
      if res.code == 200 && res['response']['result'].to_s == 'true'
        return true
      else
        puts "Error: #{res.code}"
        exit -1
      end
    end

    def wake_up!
      url = File.join(@baseurl, @id, 'wake_up')
      HTTParty.post(url, headers: @headers)
    end

    def command(cmd)
      url = File.join(@baseurl, @id, 'command', cmd)
      res = HTTParty.post(url, headers: @headers)
      return command_success?(res)
    end

    def first
      HTTParty.get(@baseurl, headers: @headers)['response'].first
    end

    def info
      @info
    end

    def inside_temp
      @info['climate_state']['inside_temp']
    end
    
    def outside_temp
      @info['climate_state']['outside_temp']
    end
    
    def driver_temp_setting
      @info['climate_state']['driver_temp_setting']
    end
    
    def passenger_temp_setting
      @info['climate_state']['passenger_temp_setting']
    end
  end
end
