module SherlockHomes

  class Pipeline
    include Visiflow::Workflow

    context do
      attribute :raw_location, String
      attribute :location, Geocoder::Result::Google

      attribute :raw_redfin, SherlockHomes::Redfin
      attribute :raw_zillow, Rubillow::Models::DeepSearchResult
      attribute :raw_trulia, SherlockHomes::Trulia

      attribute :redfin, Property
      attribute :zillow, Property
      attribute :trulia, Property

      attribute :property, Property
    end

    def self.steps
      [
        {geocode: {success: :scrape_property_info}},
        {scrape_property_info: {success: :map_property_info}},
        {map_property_info: {success: :combine_property_info}},
        :combine_property_info
      ]
    end

    def geocode(raw_location: required)
      location = SherlockHomes::Locator.search(raw_location)
      Visiflow::Response.success(location: location)
    end

    def scrape_property_info(location: required)
      raw_zillow = query_zillow_by_location location
      raw_redfin = scrape_redfin_by_location location
      raw_trulia = scrape_trulia_by_location location
      Visiflow::Response.success(raw_redfin: raw_redfin, raw_zillow: raw_zillow, raw_trulia: raw_trulia)
    end

    def map_property_info(raw_redfin: required, raw_zillow: required, raw_trulia: required)
      redfin = Mapper::Redfin.map(raw_redfin)
      zillow = Mapper::Zillow.map(raw_zillow)
      trulia = Mapper::Trulia.map(raw_trulia)
      Visiflow::Response.success(redfin: redfin, zillow: zillow, trulia: trulia)
    end

    def combine_property_info(redfin: required, zillow: required, trulia: required)
      property = Normalizer.new(redfin: redfin, zillow: zillow, trulia: trulia).normalize
      Visiflow::Response.success(property: property)
    end

    private

    def query_zillow_by_location(l)
      address = "#{l.street_number} #{l.route}"
      citystatezip = "#{l.city}, #{l.state_code} #{l.postal_code}"
      Zillow.new.search(address, citystatezip)
    end

    def scrape_redfin_by_location(l)
      url = URI.encode("https://www.redfin.com/stingray/do/query-location?v=1&location=#{l.formatted_address}")
      property_url = SherlockHomes::Redfin.property_url_from(url)
      SherlockHomes::Redfin.find(property_url)
    end

    def scrape_trulia_by_location(l)
      url = URI.encode("http://www.trulia.com/submit_search?tst=h&search=#{l.formatted_address}")
      Trulia.find(url)
    end
  end

end
