require 'spec_helper'

describe Rentjuicer::Client do

  context "basic" do
    before do
      @rentjuicer = new_rentjuicer
    end

    it "should set the api_key" do
      @rentjuicer.api_key.should == RENTJUICER_API_KEY
      @rentjuicer.http_timeout.should == nil
    end

    it "should set the base uri" do
      @rentjuicer.class.base_uri.should == "http://api.rentjuice.com/#{RENTJUICER_API_KEY}"
    end
  end

  context "timeout" do
    before do
      @rentjuicer = new_timeout_5_rentjuicer
    end

    it "should set the api_key" do
      @rentjuicer.api_key.should == RENTJUICER_API_KEY
      @rentjuicer.http_timeout.should == 5
    end

    it "should set the base uri" do
      @rentjuicer.class.base_uri.should == "http://api.rentjuice.com/#{RENTJUICER_API_KEY}"
    end
  end
end
