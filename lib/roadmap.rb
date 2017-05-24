def get_roadmap(id)
  response = self.class.get(set_uri("roadmaps/#{id}"), headers: {"authorization" => @auth_token})
  @roadmap_data = JSON.parse(response.body)
end

def get_checkpoint(id)
  response = self.class.get(set_uri("checkpoints/#{id}"), headers: {"authorization" => @auth_token})
  @checkpoint_data = JSON.parse(response.body)
end
