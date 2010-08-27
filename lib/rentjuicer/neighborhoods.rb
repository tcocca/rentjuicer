module Rentjuicer
  class Neighborhoods
    
    attr_accessor :client, :resource
    
    def initialize(client)
      self.client = client
      self.resource = "/neighborhoods.json"
    end
    
    def find_all
      Response.new(self.client.class.get(resource))
    end
    
  end
end
