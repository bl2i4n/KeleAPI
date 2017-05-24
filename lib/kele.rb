require "httparty"
require "json"

class Kele
  attr_reader :email, :password
  include HTTParty

  def initialize(email, password)
    response = self.class.post(set_uri("sessions"), body: {email: email, password: password})
    if response.code == 401
      puts "Invalid entry. Please try again."
    else
      @auth_token = response['auth_token']
    end
  end

  def get_me
    response = self.class.get(set_uri("users/me"), headers: {"authorization" => @auth_token})
    @my_data = JSON.parse(response.body)
  end

  def get_mentor_availability(id)
    resposne = self.class.get(ser_uri("mentors/#{id}/student_availability"), headers: {"authorization" => @auth_token})
    @mentor_data = JSON.parse(response.body)
  end

  private

  def set_uri(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
