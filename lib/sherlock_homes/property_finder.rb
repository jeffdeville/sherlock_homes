module SherlockHomes

  class ZillowServiceError < RuntimeError; end
  class AddressResolveError < RuntimeError; end
  class NoPropertyError < RuntimeError; end

  class PropertyFinder

    def initialize
      Rubillow.configure { |c| c.zwsid = SherlockHomes.configuration.zillow_key }
    end

    def search(address: '', citystatezip: '')
      property = Rubillow::PropertyDetails.deep_search_results(address: address, citystatezip: citystatezip)
      error_code = property.code.to_i
      # For error_code meanings see http://www.zillow.com/howto/api/GetDeepSearchResults.htm
      raise ZillowServiceError, property.message if ((1..4).to_a+[505]).include?(error_code)
      raise AddressResolveError, property.message if [500, 501, 503, 506, 507, 508].include?(error_code)
      raise NoPropertyError, property.message if [502, 504].include?(error_code)
      property
    end

  end

end
