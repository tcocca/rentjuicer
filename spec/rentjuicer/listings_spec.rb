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
        196149, 195626, 195613, 195592, 195583, 195582, 195562, 194330, 193565, 190074, 
        97694, 38101
      ]
      mock_get('/listings.json', 'find_all_by_ids.json', {
        :rentjuice_id => @find_ids.join(','),
        :order_by => "rent",
        :order_direction => "asc"
      })
      mock_get('/listings.json', 'find_all_by_ids_2.json', {
        :rentjuice_id => @find_ids.join(','),
        :order_by => "rent",
        :order_direction => "asc",
        :page => "2"
      })
      @properties = @listings.find_all_by_ids(@find_ids.join(','))
    end
    
    it { @properties.should be_kind_of(Array) }
    
    it "should only return properties for requested ids" do
      @property_ids = @properties.collect{|p| p.rentjuice_id}
      @find_ids.each do |id|
        @property_ids.should include(id)
      end
    end
  end
  
  context "find_all" do
    before do
      search_params = {
        :neighborhoods => "Fenway",
        :max_rent => "2000",
        :min_beds => "2"
      }
      mock_parms = search_params.merge!(:order_by => "rent", :order_direction => "asc")
      mock_get('/listings.json', 'find_all_1.json', mock_parms)
      mock_get('/listings.json', 'find_all_2.json', mock_parms.merge!(:page => "2"))
      mock_get('/listings.json', 'find_all_3.json', mock_parms.merge!(:page => "3"))
      @properties = @listings.find_all(search_params)
    end
    
    it { @properties.should be_kind_of(Array)}
    
  end
  
end
