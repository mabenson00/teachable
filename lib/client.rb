class Client 
  require 'oj'
  require 'faraday'
  require 'pry'
  require 'json'

  API_ENDPOINT = "https://todoable.teachable.tech/api"
  AUTHENTICATION_ENDPOINT = "https://todoable.teachable.tech/api/authenticate"

  attr_reader :token, :api_endpoint, :username, :password

  # Client.new(username: "michael.alexander.benson@gmail.com", password: "todoable")
  def initialize(token: nil, username: nil, password: nil)
    @token = token
    @username = username 
    @password = password

    raise "Please enter a username/password or token" if incomplete_credentials?

    authenticate
  end

  def lists(username)
    request(
      http_method: :get,
      endpoint: "/lists"
    )
  end



  private
  
  def get_token 
    return unless username && password

    request(
      http_method: :post,
      endpoint: "",
      authentication: true,
    )
  end
  
  def authenticate 
    get_token unless valid_token?
  end

  def valid_token?
    token && (expires_at.nil? || DateTime.now <= expires_at )
  end

  def authentication_client 
    @_client ||= Faraday.new(AUTHENTICATION_ENDPOINT) do |client|
      client    .headers["Accept"] = "application/json"
      client.headers["Content-Type"] = "application/json"
      client.basic_auth(@user, @password)
      client.adapter Faraday.default_adapter
    end
  end

  def client
    @_client ||= Faraday.new(API_ENDPOINT) do |client|
      client.headers["Authorization"] = "token #{@token}" if @token
      client.headers["Accept"] = "application/json"
      client.headers["Content-Type"] = "application/json"
      client.adapter Faraday.default_adapter
    end
  end

  def request(http_method:, endpoint:, params: {}, authentication: false)
    if !authentication
      response = client.public_send(http_method, endpoint, params.to_json)
    else 
      response = authentication_client.public_send(http_method, endpoint, params.to_json)
    end
    raise "Unauthorized" if response.status == 401
    Oj.load(response.body)
  end

  def incomplete_credentials?
    (@username.nil? || @password.nil?) && token.nil?
  end
end
