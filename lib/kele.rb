require "httparty"
require "json"
require "./lib/roadmap.rb"

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

  private

  def set_uri(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
