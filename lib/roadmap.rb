require 'httparty'
require 'json'

module Roadmap

  # def get_roadmap(id)
  #   response = self.class.get(set_uri("roadmaps/#{id}"), headers: {"authorization" => @auth_token})
  #   @roadmap_data = JSON.parse(response.body)
  # end
  #
  # def get_checkpoint(id)
  #   response = self.class.get(set_uri("checkpoints/#{id}"), headers: {"authorization" => @auth_token})
  #   @checkpoint_data = JSON.parse(response.body)
  # end
  def get_roadmap(roadmap_id)
    response = Roadmap.get(
            "#{@base_url}/roadmaps/#{roadmap_id}",
      headers: { "authorization" => @auth_token }
    )

    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = Roadmap.get(
            "#{@base_url}/checkpoints/#{checkpoint_id}",
      headers: { "authorization" => @auth_token }
    )

        JSON.parse(response.body)
  end



end
