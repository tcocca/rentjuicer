module Rentjuicer
  class Lead
    
    attr_accessor :client, :resource
    
    def initialize(client)
      self.client = client
      self.resource = "/leads.add.json"
    end
    
    def create(name, params = {})
      params.merge!(:name => name)
      Response.new(self.client.class.get(resource, :query => params))
    end
    
  end
end
