require 'spec_helper'

describe Rentjuicer::Lead do
  before do
    @rentjuicer = new_rentjuicer
    @lead = Rentjuicer::Lead.new(@rentjuicer)
  end
  
  context "a successfull creation" do
    before do
      mock_get(@lead.resource, 'lead.json', :name => 'Tom Cocca')
    end
  
    it "should not return an error on create" do
      lambda {
        @lead.create('Tom Cocca')
      }.should_not raise_exception
    end
    
    it "should not return an error on create!" do
      lambda {
        @lead.create!('Tom Cocca')
      }.should_not raise_exception
    end
    
    it "should be a success?" do
      @response = @lead.create('Tom Cocca')
      @response.success?.should be_true
    end
  end
  
  
  context "unsucessful submission" do
    before do
      mock_get(@lead.resource, 'lead_error.json', :name => '')
    end
    
    it "should return an error on create!" do
      lambda {
        @lead.create!('')
      }.should raise_exception(Rentjuicer::Error, "Rentjuicer Error: invalid parameter - `name` is required (code: 3)")
    end
    
    it "should not return an error on create" do
      lambda {
        @lead.create('')
      }.should_not raise_exception
    end
    
    it "should not be a successful submission on create" do
      @result = @lead.create('')
      @result.success?.should be_false
    end
  end
end
