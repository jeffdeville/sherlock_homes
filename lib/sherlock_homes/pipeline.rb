module SherlockHomes

  class Pipeline
    include Visiflow::Workflow

    context do
      attribute :raw_location, String
      attribute :location, Geocoder::Result::Google

      attribute :redfin, Property
      attribute :zillow, Property
      attribute :trulia, Property

      attribute :property, Property
    end

    def self.steps
      [
        {geocode: {success: :search_redfin}},
        {search_redfin: {success: :search_zillow}},
        {search_zillow: {success: :search_trulia}},
        {search_trulia: {success: :combine_property_info}},
        :combine_property_info
      ]
    end

    def geocode(raw_location: required)
      location = SherlockHomes::Locator.search(raw_location)
      Visiflow::Response.success(location: location)
    end

    def search_redfin(location: required)
      raw_redfin = scrape_redfin_by_location(location)
      redfin = Mapper::Redfin.map(raw_redfin)
      Visiflow::Response.success(redfin: redfin)
    end

    def search_zillow(location: required)
      raw_zillow = query_zillow_by_location location
      zillow = Mapper::Zillow.map(raw_zillow)
      Visiflow::Response.success(zillow: zillow)
    end

    def search_trulia(location: required)
      raw_trulia = scrape_trulia_by_location location
      trulia = Mapper::Trulia.map(raw_trulia)
      Visiflow::Response.success(trulia: trulia)
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
      property_url = SherlockHomes::Scraper::Redfin.property_url_from(url)
      SherlockHomes::Scraper::Redfin.find(property_url)
    end

    def scrape_trulia_by_location(l)
      url = URI.encode("http://www.trulia.com/submit_search?tst=h&search=#{l.formatted_address}")
      Scraper::Trulia.find(url)
    end
  end

end
