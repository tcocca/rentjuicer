module Rentjuicer
  class Client
    
    include HTTParty
    format :json
    
    attr_accessor :api_key
    
    def initialize(api_key)
      self.api_key = api_key
      self.class.base_uri "api.rentjuice.com/#{self.api_key}"
    end
    
  end
end
