RENTJUICER_API_KEY = YAML.load_file(File.join(File.dirname(__FILE__), '/../rentjuicer_api_key.yml'))["api_key"]

def new_rentjuicer
  Rentjuicer::Client.new(RENTJUICER_API_KEY)
end

def new_timeout_5_rentjuicer
  Rentjuicer::Client.new(RENTJUICER_API_KEY, 5)
end

def mock_get(resource, response_fixture, params = {})
  url = "http://api.rentalapp.zillow.com/#{RENTJUICER_API_KEY}#{resource}"
  unless params.blank?
    stub_http_request(:get, url).with(:query => params).to_return(:body => mocked_response(response_fixture))
  else
    stub_http_request(:get, url).to_return(:body => mocked_response(response_fixture))
  end
end

def mocked_response(response_fixture)
  File.read(File.join(File.dirname(__FILE__), '/../responses', response_fixture))
end

def httparty_get(resource, response_fixture, params = {})
  url = "http://api.rentalapp.zillow.com/#{RENTJUICER_API_KEY}#{resource}"
  mock_get(resource, response_fixture, params)
  HTTParty.get url, :format => :json
end
