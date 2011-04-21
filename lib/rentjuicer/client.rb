module Rentjuicer
  class Client
    
    include HTTParty
    format :json
    
    attr_accessor :api_key
    
    def initialize(api_key)
      self.api_key = api_key
      self.class.base_uri "api.rentjuice.com/#{self.api_key}"
    end
    
    def process_get(resource, params = {})
      begin
        unless params.blank?
          self.class.get(resource, :query => params)
        else
          self.class.get(resource)
        end
      rescue Timeout::Error
        {"status" => "timeout", "code" => "0", "message" => "Rentjuice API is timing out."}
      rescue Exception
        {"status" => "busted", "code" => "0", "message" => "Rentjuice API is erroring."}
      end
    end
    
  end
end
