module Rentjuicer
  class Response

    attr_accessor :body

    def initialize(response, raise_error = false)
      rash_response(response)
      raise Error.new(self.body.code, self.body.message) if !success? && raise_error
    end

    def success?
      self.body && !self.body.blank? && self.body.respond_to?(:status) && self.body.status == "ok"
    end

    def method_missing(method_name, *args)
      if self.body.respond_to?(method_name)
        self.body.send(method_name)
      else
        super
      end
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
