require "httparty"
require "json"
require "./lib/roadmap.rb"
require 'rubygems'
require 'test/unit'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "log/vcr_cassettes"
  config.hook_into :webmock
end

class VCRTest < Test::Unit::TestCase
  def test_bloc_dot_com
    VCR.use_cassette("synopsis") do
      response = Net::HTTP.get_response(URI('https://www.bloc.io/api/v1/'))
      assert_match 'https://www.bloc.io/api/v1/', response.body
    end
  end
end


class Kele
  attr_reader :email, :password
  include HTTParty
  include Roadmap

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
    response = self.class.get(set_uri("mentors/#{id}/student_availability"), headers: {"authorization" => @auth_token})
    @mentor_data = JSON.parse(response.body)
  end

  def get_messages(page)
    response = self.class.get(set_uri("message_threads"), {headers: {authorization: @auth_token}, body: {"page": "#{page}"}})
    @messages = JSON.parse(response.body)
  end

  def create_message(from, to, message)
    @from = from
    @to = to
    @message = message
    response = self.class.post(set_uri("messages"), {headers: {authorization: @auth_token}, body: {sender: @from, recipient_id: @to, "stripped-text" => @message }})
  end

  def create_submission(id, assignment_branch, assignment_commit_link, comment)
    @id = id
    @assignment_branch = assignment_branch
    @assignment_commit_link = assignment_commit_link
    @comment = comment
    response = self.class.post(set_uri("checkpoint_submissions"),
    {headers: {authorization: @auth_token},
     body: {assignment_branch: @assignment_branch, assignment_commit_link: @assignment_commit_link, checkpoint_id: @id, comment: @comment, enrollment_id: 25719}})
  end

  def update_submission(id, checkpoint_id, enrollment_id)
    @id = id
    @checkpoint_id = checkpoint_id
    @enrollment_id = enrollment_id
    response = self.class.post(set_uri("updated_submissions"),
    {headers: {authorization: @auth_token},
     body: {id: @id, checkpoint_id: @checkpoint_id, enrollment_id: 25719}})
  end

  private

  def set_uri(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
