require 'httparty'
require 'tesla/auth'

module Tesla
  class Vehicle
    def initialize(id = nil)
      @api_url = 'https://owner-api.teslamotors.com/api/1'
      @info = Hash.new

      auth = Auth.new
      unless auth.logged_in?
        puts "Please log in first"
        exit -1
      end

      @headers = {
        'Authorization': "Bearer #{auth.access_token}",
        'User-Agent': 'tesla-cli-ruby'
      }

      if id
        @id = id
      elsif auth.default_vehicle
        @id = auth.default_vehicle
      else
        @id = first['id']
        teslarc = JSON.parse(File.read(File.join(ENV['HOME'], '.teslarc')))
        teslarc['default_vehicle'] = @id
        File.write(File.join(ENV['HOME'], '.teslarc'), teslarc.to_json)
      end
      
      fetch
    end

    def fetch
      endpoint = "#{@api_url}/vehicles/#{@id}/vehicle_data"
      result = JSON.parse(HTTParty.get(endpoint, headers: @headers).body)
      
      if result['error'] && result['error'].include?('vehicle unavailable')
        puts 'Vehicle unavailable, trying to wake up...'
        wake_up!
        exit -1
      end

      @info = result['response']
    end

    def wake_up!
      endpoint = "#{@api_url}/vehicles/#{@id}/wake_up"
      result = JSON.parse(HTTParty.post(endpoint, headers: @headers).body)
    end

    def first
      endpoint = "#{@api_url}/vehicles"
      result = HTTParty.get(endpoint, headers: @headers)
      JSON.parse(result.body)['response'][0]
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
