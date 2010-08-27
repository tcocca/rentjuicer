$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rentjuicer'
require 'spec'
require 'spec/autorun'
require 'webmock/rspec'

RENTJUICER_API_KEY = YAML.load_file(File.join(File.dirname(__FILE__), 'rentjuicer_api_key.yml'))["api_key"]

Spec::Runner.configure do |config|
  config.include WebMock
end

def new_rentjuicer
  Rentjuicer::Client.new(RENTJUICER_API_KEY)
end

def mock_get(resource, response_fixture, params = {})
  url = "http://app.rentjuice.com/api/#{RENTJUICER_API_KEY}#{resource}"
  unless params.blank?
    stub_http_request(:get, url).with(:query => params).to_return(:body => mocked_response(response_fixture))
  else
    stub_http_request(:get, url).to_return(:body => mocked_response(response_fixture))
  end
end

def mocked_response(response_fixture)
  File.read(File.join(File.dirname(__FILE__), 'responses', response_fixture))
end
