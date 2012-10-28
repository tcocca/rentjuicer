require 'spec_helper'

describe Rentjuicer::Response do

  context "should raise errors" do
    before do
      @rentjuicer = new_rentjuicer
      @neighborhoods = Rentjuicer::Neighborhoods.new(@rentjuicer)
      mock_get(@neighborhoods.resource, 'error.json')
    end

    it "should not raise an exception" do
      lambda {
        @neighborhoods.find_all
      }.should_not raise_exception
    end

    it "should not be a success" do
      @response = Rentjuicer::Response.new(httparty_get('/neighborhoods.json', 'error.json'))
      @response.success?.should be_false
    end
  end

  context "passing raise_errors = true" do
    it "should raise errors when raise_errors is false" do
      lambda {
        Rentjuicer::Response.new(httparty_get('/neighborhoods.json', 'error.json'), true)
      }.should raise_exception(Rentjuicer::Error, "Rentjuicer Error: Invalid API key. (code: 1)")
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

  context "method missing" do
    before do
      @rentjuicer = new_rentjuicer
      @listings = Rentjuicer::Listings.new(@rentjuicer)
      mock_get('/listings.json', 'listings.json', {
        :neighborhoods => "South Boston",
        :order_by => "rent",
        :order_direction => "asc"
      })
      @results = @listings.search(:neighborhoods => "South Boston")
    end

    it "should allow response.body methods to be called on response" do
      body = stub(:total_count => 25)
      @results.body = body
      @results.total_count.should == 25
    end

    it "should return @properties.size when total_count is nil for total_results" do
      @results.body.stub!(:total_count).and_return(nil)
      @results.total_results.should == 20
    end

    it "should call super if body does not response to the method" do
      lambda { @results.bad_method }.should raise_error(NoMethodError, /undefined method `bad_method'/)
    end
  end

end
