require 'spec_helper'

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

      it { @result.should respond_to(:properties, :paginator, :client) }

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

  context "mls_search" do
    before do
      mock_get('/listings.json', 'mls_listings.json', {
        :include_mls => "1",
        :order_by => "rent",
        :order_direction => "asc"
      })
      @result = @listings.search(:include_mls => "1")
    end

    context "search response" do
      it { @result.mls_results?.should be_true }

      it "should return an array of uniq property mls_disclaimers" do
        @result.mls_disclaimers.should == [
          "The property listing data and information, or the Images, set forth herein were provided to MLS Property Information Network, Inc. from third party sources, including sellers, lessors and public records, and were compiled by MLS Property Information Network, Inc.  The property listing data and information, and the Images, are for the personal, non-commercial use of consumers having a good faith interest in purchasing or leasing listed properties of the type displayed to them and may not be used for any purpose other than to identify prospective properties which such consumers may have a good faith interest in purchasing or leasing.  MLS Property Information Network, Inc. and its subscribers disclaim any and all representations and warranties as to the accuracy of the property listing data and information, or as to the accuracy of any of the Images, set forth herein."
        ]
      end
    end
  end
  
  context "find_by_id" do
    before do
      mock_get('/listings.json', 'find_by_id.json', {
        :rentjuice_id => "200306"
      })
      @listing = @listings.find_by_id(200306)
    end

    it { @listing.should be_kind_of(Rentjuicer::Listing) }
  end

  context "find_by_id missing" do
    before do
      mock_get('/listings.json', 'null_listings.json', {
        :rentjuice_id => "1"
      })
      @listing = @listings.find_by_id(1)
    end

    it { @listing.should be_nil }
  end

  context "nil listings" do
    context "null listings" do
      before do
        mock_get('/listings.json', 'null_listings.json', {
          :limit => "20",
          :order_by => "rent",
          :order_direction => "asc"
        })
        @results = @listings.search(:limit => 20, :order_by => "rent", :order_direction => "asc")
      end

      it { @results.properties.should be_empty }
    end

    context "missing listings" do
      before do
        mock_get('/listings.json', 'missing_listings.json', {
          :limit => "20",
          :order_by => "rent",
          :order_direction => "asc"
        })
        @results = @listings.search(:limit => 20, :order_by => "rent", :order_direction => "asc")
      end

      it { @results.properties.should be_empty }
    end

    context "empty response" do
      before do
        mock_get('/listings.json', 'empty_response.json', {
          :limit => "20",
          :order_by => "rent",
          :order_direction => "asc"
        })
        @results = @listings.search(:limit => 20, :order_by => "rent", :order_direction => "asc")
      end

      it { @results.properties.should be_empty }
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

    context "passing a string of ids" do
      before do
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

    context "passing an array of ids" do
      before do
        @properties = @listings.find_all_by_ids(@find_ids)
      end

      it { @properties.should be_kind_of(Array) }

      it "should only return properties for requested ids" do
        @property_ids = @properties.collect{|p| p.rentjuice_id}
        @find_ids.each do |id|
          @property_ids.should include(id)
        end
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
