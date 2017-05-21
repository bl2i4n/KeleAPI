require "httparty"

class Kele
  attr_reader :email, :password
  include HTTParty

  def initialize(email, password)
    base_uri = 'https://www.bloc.io/api/v1/sessions'
    response = self.class.post(base_uri, body: {email: email, password: password})
    if response.code == 401
      puts "Invalid entry. Please try again."
    else
      @auth_token = response['auth_token']
    end
  end

end
