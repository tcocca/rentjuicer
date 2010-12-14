require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rentjuicer::Listing do
  
  before do
    @listing = Rentjuicer::Listing.new(valid_listing_rash)
  end
  
  it "should create methods from all hash keys" do
    @listing.should respond_to(
      "address", "agent_phone", "bedrooms", "latitude", "title", "photos", "featured", "url", "date_available", 
      "square_footage", "agent_email", "rental_terms", "street", "fee", "property_type", "cross_street", "unit_number", 
      "custom_fields", "last_updated", "features", "bathrooms", "rent", "neighborhoods", "street_number", "floor_number", 
      "longitude", "description", "agent_name", "rentjuice_id"
    )
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
  
  context "mls_listing" do
    context "mlspin - 2 br tags" do
      before do
        @listing = Rentjuicer::Listing.new(valid_listing_rash.merge({
          "source_type" => "mls",
          "source_name" => "MLS PIN",
          "attribution" => "This listing courtesy of Holly Kampler at Classic Realty<br \/><br \/>The property listing data and information, or the Images, set forth herein were provided to MLS Property Information Network, Inc. from third party sources, including sellers, lessors and public records, and were compiled by MLS Property Information Network, Inc.  The property listing data and information, and the Images, are for the personal, non-commercial use of consumers having a good faith interest in purchasing or leasing listed properties of the type displayed to them and may not be used for any purpose other than to identify prospective properties which such consumers may have a good faith interest in purchasing or leasing.  MLS Property Information Network, Inc. and its subscribers disclaim any and all representations and warranties as to the accuracy of the property listing data and information, or as to the accuracy of any of the Images, set forth herein."
        }))
      end
      
      it { @listing.mls_listing?.should be_true }
      it { @listing.source_name.should == "MLS PIN" }
      it { @listing.attribution.should == "This listing courtesy of Holly Kampler at Classic Realty<br \/><br \/>The property listing data and information, or the Images, set forth herein were provided to MLS Property Information Network, Inc. from third party sources, including sellers, lessors and public records, and were compiled by MLS Property Information Network, Inc.  The property listing data and information, and the Images, are for the personal, non-commercial use of consumers having a good faith interest in purchasing or leasing listed properties of the type displayed to them and may not be used for any purpose other than to identify prospective properties which such consumers may have a good faith interest in purchasing or leasing.  MLS Property Information Network, Inc. and its subscribers disclaim any and all representations and warranties as to the accuracy of the property listing data and information, or as to the accuracy of any of the Images, set forth herein."}
      it { @listing.courtesy_of.should == "This listing courtesy of Holly Kampler at Classic Realty"}
      it { @listing.mls_disclaimer.should == "The property listing data and information, or the Images, set forth herein were provided to MLS Property Information Network, Inc. from third party sources, including sellers, lessors and public records, and were compiled by MLS Property Information Network, Inc.  The property listing data and information, and the Images, are for the personal, non-commercial use of consumers having a good faith interest in purchasing or leasing listed properties of the type displayed to them and may not be used for any purpose other than to identify prospective properties which such consumers may have a good faith interest in purchasing or leasing.  MLS Property Information Network, Inc. and its subscribers disclaim any and all representations and warranties as to the accuracy of the property listing data and information, or as to the accuracy of any of the Images, set forth herein."}
    end
    
    context "RAMB - no disclaimer, attribution only" do
      before do
        @listing = Rentjuicer::Listing.new(valid_listing_rash.merge({
          "source_type" => "mls",
          "source_name" => "RAMB",
          "attribution" => "This listing is courtesy of XYZ Realty"
        }))
      end
      
      it { @listing.mls_listing?.should be_true }
      it { @listing.source_name.should == "RAMB" }
      it { @listing.attribution.should == "This listing is courtesy of XYZ Realty"}
      it { @listing.courtesy_of.should == "This listing is courtesy of XYZ Realty"}
      it { @listing.mls_disclaimer.should be_nil}
    end
    
    context "MRED - 1 br and an image" do
      before do
        @listing = Rentjuicer::Listing.new(valid_listing_rash.merge({
          "source_type" => "mls",
          "source_name" => "MRED",
          "attribution" => "<img src=\"http://idx.advancedaccess.com/disclaimer/brlogo125.jpg\" style=\"float:left; padding-right:10px;\" />Listing office: XYZ Realty<br />Properties marked with the MRED approved icon are courtesy of Midwest Real Estate Data, LLC.  Information deemed reliable but not guaranteed.  Copyright&copy; 2010 Midwest Real Estate Data LLC.  All rights reserved."
        }))
      end
      
      it { @listing.mls_listing?.should be_true }
      it { @listing.source_name.should == "MRED" }
      it { @listing.attribution.should == "<img src=\"http://idx.advancedaccess.com/disclaimer/brlogo125.jpg\" style=\"float:left; padding-right:10px;\" />Listing office: XYZ Realty<br />Properties marked with the MRED approved icon are courtesy of Midwest Real Estate Data, LLC.  Information deemed reliable but not guaranteed.  Copyright&copy; 2010 Midwest Real Estate Data LLC.  All rights reserved."}
      it { @listing.courtesy_of.should == "<img src=\"http://idx.advancedaccess.com/disclaimer/brlogo125.jpg\" style=\"float:left; padding-right:10px;\" />Listing office: XYZ Realty"}
      it { @listing.mls_disclaimer.should == "Properties marked with the MRED approved icon are courtesy of Midwest Real Estate Data, LLC.  Information deemed reliable but not guaranteed.  Copyright&copy; 2010 Midwest Real Estate Data LLC.  All rights reserved."}
    end
  end
  
end
