module Rentjuicer
  class Neighborhoods

    attr_accessor :client, :resource

    def initialize(client)
      self.client = client
      self.resource = "/neighborhoods.json"
    end

    def find_all(raise_error = false)
      Response.new(self.client.process_get(resource), raise_error)
    end

    def find_all!
      find_all(true)
    end

  end
end
