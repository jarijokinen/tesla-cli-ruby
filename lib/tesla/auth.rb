require 'httparty'

module Tesla
  class Auth
    def initialize
      @logged_in = false
      @access_token = nil

      begin
        teslarc = File.read(File.join(ENV['HOME'], '.teslarc'))
      rescue SystemCallError => e
        return
      end

      begin
        teslarc_hash = JSON.parse(teslarc)
      rescue JSON::ParserError => e
        return
      end

      if teslarc_hash.has_key?('access_token')
        @logged_in = true
        @access_token = teslarc_hash['access_token']
      end
      
      if teslarc_hash.has_key?('default_vehicle')
        @default_vehicle = teslarc_hash['default_vehicle']
      end
    end

    def logged_in?
      @logged_in
    end
    
    def access_token
      @access_token
    end

    def default_vehicle
      @default_vehicle
    end

    def login(email, password)
      url = 'https://owner-api.teslamotors.com/oauth/token?grant_type=password'
      result = HTTParty.post(
        url, 
        body: {
          'grant_type': 'password',
          'client_id': 
            '81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384',
          'client_secret': 
            'c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3',
          'email': email,
          'password': password
        }.to_json,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'tesla-cli-ruby'
        })
      File.write(File.join(ENV['HOME'], '.teslarc'), result)
      File.chmod(0600, File.join(ENV['HOME'], '.teslarc'))
    end
  end
end
