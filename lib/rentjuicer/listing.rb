module Rentjuicer
  class Listing
    
    def initialize(listing)
      listing.keys.each do |key, value|
        self.instance_variable_set('@'+key, listing.send(key))
        self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
      end
    end

    def similar_listings(rj, limit = 6)
      search_params = {
        :limit => limit + 1,
        :min_rent => self.rent * 0.9,
        :max_rent => self.rent * 1.1,
        :min_beds => if (self.bedrooms - 1) <= 0 then 0 else (self.bedrooms - 1) end,
        :max_beds => self.bedrooms + 1,
        :min_baths => if (self.bathrooms - 1) <= 0 then 0 else (self.bathrooms - 1) end,
        :max_baths => self.bathrooms + 1,
        :neighborhoods => self.neighborhood_name
      }

      similar = []
      listings = Rentjuicer::Listings.new(rj)
      listings.search(search_params).properties.each do |prop|
        similar << prop unless prop.id == self.id
        break if similar.size == limit
      end
      similar
    end

    def id
      rentjuice_id
    end

    def thumb_pic
      main_pic[:thumbnail] if sorted_photos
    end

    def first_pic
      main_pic[:fullsize] if sorted_photos
    end

    def main_pic
      sorted_photos.detect(lambda {return sorted_photos.first}) { |photo| photo[:main_photo] }
    end

    def sorted_photos
      @sorted_pictures ||= self.photos.sort_by{|photo| photo[:sort_order]} if photos
    end

    def neighborhood_name
      self.neighborhoods.first unless neighborhoods.blank?
    end

  end
end
