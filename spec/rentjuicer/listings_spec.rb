require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rentjuicer::Listing do
  
  before do
    @rentjuicer = new_rentjuicer
    @listings = Rentjuicer::Listings.new(@rentjuicer)
  end
  
  context "search" do
    before do
      mock_get('/listings.json', 'listings.json', {
        :neighborhoods => "South Boston",
        :order_by => "rent",
        :order_direction => "asc"
      })
      @result = @listings.search(:neighborhoods => "South Boston")
    end
    
    it { @result.should be_kind_of(Rentjuicer::Listings::SearchResponse) }
    it { @result.success?.should be_true }
    
    context "search response" do
      it { @result.should be_kind_of(Rentjuicer::Response)}
      it { @result.should respond_to(:properties, :paginator) }
      
      it "should return an array of properties" do
        @result.properties.should be_kind_of(Array)
        @result.properties.each do |property|
          property.should be_kind_of(Rentjuicer::Listing)
        end
      end
      
      it "should return a will_paginate collection" do
        @result.paginator.should be_kind_of(WillPaginate::Collection)
        @result.paginator.collect{|p| p.id}.should == @result.properties.collect{|p| p.id}
      end
    end
  end
  
  context "find_by_id" do
    before do
      mock_get('/listings.json', 'find_by_id.json', {
        :rentjuice_id => "200306"
      })
      @result = @listings.find_by_id(200306)
    end
    
    it { @result.should be_kind_of(Rentjuicer::Listings::SearchResponse) }
    it { @result.success?.should be_true }
    
    it "should return no more than 1 response" do
      @result.properties.should have_at_most(1).listings
    end
  end
  
  context "featured" do
    before do
      mock_get('/listings.json', 'featured.json', {
        :featured => "1",
        :order_by => "rent",
        :order_direction => "asc"
      })
      @result = @listings.featured
    end
    
    it { @result.should be_kind_of(Rentjuicer::Listings::SearchResponse) }
    it { @result.success?.should be_true }
    
    it "should only return featured properties" do
      @result.properties.collect{|p| p.featured == 1}.size.should == @result.properties.size
    end
  end
  
  context "find_all_by_ids" do
    before do
      @find_ids = [
        200306, 200221, 200214, 200121, 199646, 198560, 197542, 197540, 197538, 196165, 
        196149, 195626, 195613, 195592, 195583, 195582, 195562, 194330, 193565, 190074
      ]
      mock_get('/listings.json', 'find_all_by_ids.json', {
        :rentjuice_id => @find_ids.join(','),
        :order_by => "rent",
        :order_direction => "asc"
      })
      @properties = @listings.find_all_by_ids(@find_ids.join(','))
    end
    
    it { @properties.should be_kind_of(Array) }
    
    it "should only return properties for requested ids" do
      @properties.each do |property|
        @find_ids.should include(property.rentjuice_id)
      end
    end
  end
  
end
