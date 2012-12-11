module Rentjuicer
  class Client

    include HTTParty
    format :json

    attr_accessor :api_key, :http_timeout

    def initialize(api_key, http_timeout = nil)
      self.api_key = api_key
      self.http_timeout = http_timeout
      self.class.base_uri "api.rentalapp.zillow.com/#{self.api_key}"
    end

    def listings
      @listings ||= Rentjuicer::Listings.new(self)
    end

    def neighborhoods
      @neighborhoods ||= Rentjuicer::Neighborhoods.new(self)
    end

    def leads
      @leads ||= Rentjuicer::Lead.new(self)
    end

    def process_get(resource, params = {})
      begin
        http_params = {}
        unless params.blank?
          http_params[:query] = params
        end
        unless self.http_timeout.nil?
          http_params[:timeout] = self.http_timeout
        end
        self.class.get(resource, http_params)
      rescue Timeout::Error
        {"status" => "timeout", "code" => "0", "message" => "Rentjuice API is timing out."}
      rescue Exception
        {"status" => "busted", "code" => "0", "message" => "Rentjuice API is erroring."}
      end
    end

  end
end
