class Client 
  require 'oj'
  require 'faraday'
  require 'pry'
  require 'json'
  require "rest-client"

  BASE_URL = "https://todoable.teachable.tech/api"

  attr_reader :token, :base_url, :username, :password, :expires_at

  # Client.new(username: "michael.alexander.benson@gmail.com", password: "todoable")
  def initialize(token: nil, username: nil, password: nil)
    @token = token
    @username = username 
    @password = password
    @base_url = BASE_URL
    raise "Please enter a username/password or token" if incomplete_credentials?

  end

  def lists(username)
    request(
      http_method: :get,
      endpoint: "/lists"
    )
  end



  private

  def request(http_method:, endpoint:, params: {})
    authenticate

    response = RestClient::Request.execute(
      method: endpoint,
      url: url(http_method),
      headers: {content_type: :json, accept: :json, Authorization: token}
      )
    Oj.load(response.body)
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
