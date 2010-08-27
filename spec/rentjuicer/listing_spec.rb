require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rentjuicer::Listing do
  
  before do
    @listing = Rentjuicer::Listing.new(valid_listing_rash)
  end
  
  it "should return rentjuice_id for id" do
    @listing.id.should == 200306
  end
  
  it "should return the first neighborhood in the array for neighborhood_name" do
    @listing.neighborhood_name.should == 'South Boston'
  end
  
  it "should return the thumbnail url of the first sorted pic for thumb_pic" do
    @listing.thumb_pic.should == "http://static.rentjuice.com/frames/2010/08/25/3008760.jpg"
  end
  
  it "should return the fullsize url of the first sorted pic for first_pic" do
    @listing.first_pic.should == "http://static.rentjuice.com/frames/2010/08/25/3008757.jpg"
  end
  
  it "should return the first element of the sorted photos for main_pic" do
    @listing.main_pic.should == Hashie::Rash.new({
      "thumbnail" => "http://static.rentjuice.com/frames/2010/08/25/3008760.jpg",
      "sort_order" => 1,
      "main_photo" => true,
      "fullsize" => "http://static.rentjuice.com/frames/2010/08/25/3008757.jpg"
    })
  end
  
  it "should return an array of photos sorted by the sort_order key for sorted_photos" do
    @listing.sorted_photos.should == sorted_photos_array
  end
  
  context "default similar listings" do
    before do
      @rentjuicer = new_rentjuicer
      mock_get('/listings.json', 'listings.json', {
          :neighborhoods => "South Boston", 
          :min_rent => "2250.0",
          :max_rent => "2750.0",
          :min_beds => "2",
          :max_beds => "4",
          :min_baths => "0",
          :max_baths => "2",
          :limit => "7",
          :order_by => "rent",
          :order_direction => "asc"
      })
      @similar_props = @listing.similar_listings(@rentjuicer)
    end
    
    it "should return an array of listings" do
      @similar_props.should be_kind_of(Array)
      @similar_props.should have_at_most(6).listings
      @similar_props.collect{|x| x.id}.should_not include(@listing.id)
    end
  end
  
  context "similar listings with custom limit" do
    before do
      @rentjuicer = new_rentjuicer
      mock_get('/listings.json', 'listings.json', {
          :neighborhoods => "South Boston", 
          :min_rent => "2250.0",
          :max_rent => "2750.0",
          :min_beds => "2",
          :max_beds => "4",
          :min_baths => "0",
          :max_baths => "2",
          :limit => "5",
          :order_by => "rent",
          :order_direction => "asc"
      })
      @similar_props = @listing.similar_listings(@rentjuicer, 4)
    end
    
    it "should return an array of listings" do
      @similar_props.should be_kind_of(Array)
      @similar_props.should have_at_most(4).listings
      @similar_props.collect{|x| x.id}.should_not include(@listing.id)
    end
  end
  
end
