require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Rentjuicer::Error" do
  
  before do
    @rentjuicer = new_rentjuicer
  end
  
  it "should set the api_key" do
    @rentjuicer.api_key.should == RENTJUICER_API_KEY
  end
  
  it "should set the base uri" do
    @rentjuicer.class.base_uri.should == "http://app.rentjuice.com/api/#{RENTJUICER_API_KEY}"
  end
  
end
