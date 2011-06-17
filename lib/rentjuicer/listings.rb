module Rentjuicer
  class Listings
    
    attr_accessor :client, :resource
    
    def initialize(client)
      self.client = client
      self.resource = "/listings.json"
    end
    
    def search(params = {})
      limit = params[:limit] || 20
      params[:order_by] ||= "rent"
      params[:order_direction] ||= "asc"
      SearchResponse.new(self.client.process_get(resource, params), limit)
    end
    
    def featured(params = {})
      params.merge!(:featured => 1)
      search(params)
    end
    
    def find_by_id(listing_id, params = {})
      response = SearchResponse.new(self.client.process_get(resource, params.merge(:rentjuice_id => listing_id)))
      (response.success? && response.properties.size > 0) ? response.properties.first : nil
    end
    
    def find_all(params = {})
      per_page = params[:limit] || 20
      all_listings = []
      
      response = search(params)
      if response.success?
        all_listings << response.properties
        total_pages = (response.total_results/per_page.to_f).ceil
        if total_pages > 1
          (2..total_pages).each do |page_num|
            resp = search(params.merge(:page => page_num))
            if resp.success?
              all_listings << resp.properties
            end
          end
        end
      end
      all_listings.flatten
    end
    
    def find_all_by_ids(listing_ids, params = {})
      listing_ids = listing_ids.split(',') if listing_ids.is_a?(String)
      all_listings = []
      listing_ids.in_groups_of(500, false).each do |group|
        group.delete_if{|x| x.nil?}
        all_listings << find_all(params.merge(:rentjuice_id => group.join(',')))
      end
      all_listings.flatten
    end
    
    class SearchResponse < Rentjuicer::Response
      
      attr_accessor :limit, :paginator_cache
      
      def initialize(response, limit = 20)
        super(response)
        @limit = limit
      end
      
      def properties
        return [] if self.body.listings.blank?
        @cached_properties ||= begin
          props = []
          self.body.listings.each do |listing|
            props << Rentjuicer::Listing.new(listing)
          end
          props
        end
      end
      
      def total_results
        self.body.total_count ? self.body.total_count : properties.size
      end
      
      def mls_results?
        @has_mls_properties ||= properties.any?{|property| property.mls_listing?}
      end
      
      def mls_disclaimers
        @disclaimers ||= properties.collect{|property| property.mls_disclaimer}.compact.uniq
      end
      
      def paginator
        paginator_cache if paginator_cache
        self.paginator_cache = WillPaginate::Collection.create(
          self.body.page ||= 1, 
          @limit, 
          self.total_results) do |pager|
          pager.replace properties
        end
      end
    end
    
  end
end
