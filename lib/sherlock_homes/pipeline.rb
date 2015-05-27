module SherlockHomes

  class Pipeline
    include Visiflow::Workflow

    context do
      attribute :raw_location, String
      attribute :location, Geocoder::Result::Google
      attribute :raw_property, Hash
      attribute :property, Property
    end

    def self.steps
      [
        {geocode: {success: :scrape_property_info}},
        {scrape_property_info: {success: :combine_property_info}},
        :combine_property_info
      ]
    end

    def geocode(raw_location: required)
      location = SherlockHomes::Locator.search(raw_location)
      Visiflow::Response.success(location: location)
    end

    def scrape_property_info(location: required)
      raw_property = Hash.new
      raw_property[:zillow] = query_zillow_by_location location
      raw_property[:redfin] = scrape_redfin_by_location location
      raw_property[:trulia] = scrape_trulia_by_location location
      Visiflow::Response.success(raw_property: raw_property)
    end

    def combine_property_info(raw_property: required)
      property = Normalizer.for_property raw_property
      Visiflow::Response.success(property: property)
    end

    private

    def query_zillow_by_location(l)
      address = "#{l.street_number} #{l.route}"
      citystatezip = "#{l.city}, #{l.state_code} #{l.postal_code}"
      Zillow.new.search(address, citystatezip)
    end

    def scrape_redfin_by_location(l)
      uri = URI("https://www.redfin.com/stingray/do/query-location?v=1&location=#{l.formatted_address}")
      property_url = SherlockHomes::Redfin.property_url_from(uri.to_s)
      SherlockHomes::Redfin.find(property_url)
    end

    def scrape_trulia_by_location(l)
      uri = URI("http://www.trulia.com/submit_search?tst=h&search=#{l.formatted_address}")
      Trulia.find(uri.to_s)
    end
  end

end
