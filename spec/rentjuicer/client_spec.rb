require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rentjuicer::Client do
  
  before do
    @rentjuicer = new_rentjuicer
  end
  
  it "should set the api_key" do
    @rentjuicer.api_key.should == RENTJUICER_API_KEY
  end
  
  it "should set the base uri" do
    @rentjuicer.class.base_uri.should == "http://api.rentjuice.com/#{RENTJUICER_API_KEY}"
  end
  
end
