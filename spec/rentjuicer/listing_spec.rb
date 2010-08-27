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
  
end
