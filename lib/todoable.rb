module Todoable
  class UnprocessableEntityError < StandardError; end
  
  class Client 
    require 'json'
    require "rest-client"
    require_relative 'todoable/lists'
    require_relative 'todoable/items'

    include Lists
    include Items

    BASE_URL = "https://todoable.teachable.tech/api"

    attr_reader :token, :base_url, :username, :password, :expires_at

    def initialize(token: nil, username: nil, password: nil)
      @token = token
      @username = username 
      @password = password
      @base_url = BASE_URL
      raise "Please enter a username/password or token" if incomplete_credentials?

      authenticate
    end


    private

    def api_request(http_method:, endpoint:, params: {})
      authenticate

      begin
      response = RestClient::Request.execute(
        method: http_method,
        url: url(endpoint),
        payload: params.to_json,
        headers: {content_type: :json, accept: :json, authorization: token},
        )
      rescue RestClient::UnprocessableEntity => err
        raise UnprocessableEntityError.new(JSON.parse(err.response))
      end
    end

    def errors 

    end
    def authenticate 
      get_token unless valid_token?
    end

    def valid_token?
      token &&  DateTime.now <= expires_at 
    end
    
    def get_token 
      return unless username && password

      response = RestClient::Request.execute(
      method: :post,
      url: url('authenticate'),
      user: username,
      password: password,
      headers:  {content_type: :json, accept: :json}
      )
      @token = JSON.parse(response.body)["token"]
      @expires_at = DateTime.parse(JSON.parse(response.body)["expires_at"])
    end

    def incomplete_credentials?
      (@username.nil? || @password.nil?) && token.nil?
    end

    def url(endpoint)
      "#{base_url}/#{endpoint}"
    end
  end
end
