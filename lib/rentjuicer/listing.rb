module Rentjuicer
  class Listing

    attr_accessor :client

    def initialize(listing, client)
      listing.each do |key, value|
        self.instance_variable_set("@#{key}", value)
        self.class.send(:attr_reader, key)
      end
      self.client = client
    end

    def similar_listings(limit = 6, search_options = {})
      search_params = {
        :limit => limit + 1,
        :min_rent => self.rent.to_i * 0.9,
        :max_rent => self.rent.to_i * 1.1,
        :min_beds => ((self.bedrooms.to_i - 1) <= 0 ? 0 : (self.bedrooms.to_i - 1)),
        :max_beds => self.bedrooms.to_i + 1,
        :min_baths => ((self.bathrooms.to_i - 1) <= 0 ? 0 : (self.bathrooms.to_i - 1)),
        :max_baths => self.bathrooms.to_i + 1,
        :neighborhoods => self.neighborhood_name
      }.merge(search_options)
      @cached_similars ||= begin
        similar = []
        listings = Rentjuicer::Listings.new(self.client)
        listings.search(search_params).properties.each do |prop|
          similar << prop unless prop.id == self.id
          break if similar.size == limit
        end
        similar
      end
    end

    def id
      rentjuice_id
    end

    def thumb_pic
      main_pic[:thumbnail] if main_pic
    end

    def first_pic
      main_pic[:fullsize] if main_pic
    end

    def main_pic
      @main_picture ||= sorted_photos.detect(lambda {return sorted_photos.first}) { |photo| photo[:main_photo] } if sorted_photos
    end

    def sorted_photos
      @sorted_pictures ||= self.photos.sort_by{|photo| photo[:sort_order].to_i} if photos
    end

    def neighborhood_name
      @neigh_name ||= begin
        unless neighborhoods.blank?
          if self.neighborhoods.first.is_a?(String)
            self.neighborhoods.first
          elsif self.neighborhoods.first.is_a?(Array)
            self.neighborhoods.first[1]
          end
        end
      end
    end

    def mls_listing?
      source_type && source_type == "mls"
    end

    def mls_disclaimer
      attribution_split[1].gsub('<br />', '') if mls_listing? && attribution_split && attribution_split[1]
    end

    def courtesy_of
      attribution_split[0] if mls_listing? && attribution_split && attribution_split[0]
    end

    private

    def attribution_split
      @attribution_parts ||= attribution.split('<br />', 2) unless attribution.blank?
    end

  end
end
