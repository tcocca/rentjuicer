module Rentjuicer
  class Listings
    
    attr_accessor :client, :resource
    
    def initialize(client)
      self.client = client
      self.resource = "/listings.json"
    end
    
    def find_by_id(listing_id)
      SearchResponse.new(self.client.class.get(resource, :query => {:rentjuice_id => listing_id}), 20)
    end
    
    def search(params = {})
      limit = params[:limit] || 20
      params[:order_by] ||= "rent"
      params[:order_direction] ||= "asc"
      SearchResponse.new(self.client.class.get(resource, :query => params), limit)
    end
    
    def featured(params = {})
      params.merge!(:featured => 1)
      search(params)
    end
    
    def find_all(params = {})
      per_page = params[:limit] || 20
      all_listings = []
      
      response = search(params)
      if response.success?
        all_listings << response.properties
        total_pages = (response.body.total_count/per_page.to_f).ceil
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
    
    def find_all_by_ids(listing_ids)
      all_listings = []
      listing_ids.split(',').in_groups_of(500).each do |group|
        group.delete_if{|x| x.nil?}
        all_listings << find_all(:rentjuice_id => group.join(","))
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
        return [] if @body.listings.blank?
        props = []
        @body.listings.each do |listing|
          props << Rentjuicer::Listing.new(listing)
        end
        props
      end
      
      def paginator
        paginator_cache if paginator_cache
        self.paginator_cache = WillPaginate::Collection.create(
          @body.page, 
          @limit, 
          (@body.total_count ? @body.total_count : properties.size)) do |pager|
          pager.replace properties
        end
      end
    end
    
  end
end