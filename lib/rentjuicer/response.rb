module Rentjuicer
  class Response
    
    attr_accessor :body
    
    def initialize(response, raise_error = true)
      @body = rash_response(response)
      raise Error.new(@body.code, @body.message) if !success? && raise_error
    end
    
    def success?
      @body.status == "ok"
    end
    
    private
    
    def rash_response(response)
      if response.is_a?(Array)
        self.body = []
        response.each do |b|
          if b.is_a?(Hash)
            self.body << Hashie::Rash.new(b)
          else
            self.body << b
          end
        end
      elsif response.is_a?(Hash)
        self.body = Hashie::Rash.new(response)
      else
        self.body = response
      end
    end
    
  end
end
