require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rentjuicer::Response do
  
  context "should raise errors" do
    before do
      @rentjuicer = new_rentjuicer
      @neighborhoods = Rentjuicer::Neighborhoods.new(@rentjuicer)
      mock_get(@neighborhoods.resource, 'error.json')
    end
    
    it "should raise an exception" do
      lambda {
        @neighborhoods.find_all
      }.should raise_exception
    end
  end
  
  context "passing raise_errors = false" do
    it "should not raise errors when raise_errors is false" do
      lambda {
        Rentjuicer::Response.new(httparty_get('/neighborhoods.json', 'error.json'), false)
      }.should_not raise_exception
    end
    
    it "should not be a success" do
      @response = Rentjuicer::Response.new(httparty_get('/neighborhoods.json', 'error.json'), false)
      @response.success?.should be_false
    end
  end
  
  context "should return a response" do
    before do
      @rentjuicer = new_rentjuicer
      @neighborhoods = Rentjuicer::Neighborhoods.new(@rentjuicer)
      mock_get(@neighborhoods.resource, 'neighborhoods.json')
    end
    
    it "should not raise an exception" do
      lambda {
        @neighborhoods.find_all
      }.should_not raise_exception
    end
    
    it "should be a success" do
      @results = @neighborhoods.find_all
      @results.success?.should be_true
    end
  end
  
end
