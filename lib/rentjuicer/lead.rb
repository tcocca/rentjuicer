module Rentjuicer
  class Lead

    attr_accessor :client, :resource

    def initialize(client)
      self.client = client
      self.resource = "/leads.add.json"
    end

    def create(name, params = {}, raise_error = false)
      params.merge!(:name => name)
      Response.new(self.client.process_get(resource, params), raise_error)
    end

    def create!(name, params = {})
      create(name, params = {}, true)
    end

  end
end
