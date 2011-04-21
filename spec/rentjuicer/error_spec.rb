require 'spec_helper'

describe Rentjuicer::Error do
  
  before do
    @rentjuicer = new_rentjuicer
    @neighborhoods = Rentjuicer::Neighborhoods.new(@rentjuicer)
    mock_get(@neighborhoods.resource, 'error.json')
  end
  
  it "should not return an error" do
    lambda {
      @neighborhoods.find_all
    }.should_not raise_exception
  end
  
  it "should return an error" do
    lambda {
      @neighborhoods.find_all!
    }.should raise_exception(Rentjuicer::Error, "Rentjuicer Error: Invalid API key. (code: 1)")
  end
  
end
