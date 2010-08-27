require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rentjuicer::Neighborhoods do
  
  before do
    @rentjuicer = new_rentjuicer
    @neighborhoods = Rentjuicer::Neighborhoods.new(@rentjuicer)
    mock_get(@neighborhoods.resource, 'neighborhoods.json')
  end
  
  context "find_all" do
    before do
      @response = @neighborhoods.find_all
    end
    
    it "should be a success" do
      @response.success?.should be_true
    end
    
    it "should return Rash for response for body" do
      @response.body.should be_kind_of(Hashie::Rash)
    end
    
    it "should set an array of neighborhoods on the body" do
      @response.body.neighborhoods.should be_kind_of(Array)
      @response.body.neighborhoods.first.should be_kind_of(Hashie::Rash)
    end
  end
  
end
