module SherlockHomes

  class ZillowServiceError < RuntimeError; end
  class AddressResolveError < RuntimeError; end
  class NoPropertyError < RuntimeError; end
  class NoEstimateError < RuntimeError; end
  class NoCompsError < RuntimeError; end

  class Zillow

    def search(address, citystatezip)
      property = Rubillow::PropertyDetails.deep_search_results(address: address, citystatezip: citystatezip)
      error_code = property.code.to_i
      # For error_code meanings see http://www.zillow.com/howto/api/GetDeepSearchResults.htm
      # (Presence of address and citystatezip is ensured by Rubillow)
      raise ZillowServiceError, property.message if ((1..4).to_a+[505]).include?(error_code)
      raise AddressResolveError, property.message if [500, 501, 503, 506, 507, 508].include?(error_code)
      raise NoPropertyError, property.message if [502, 504].include?(error_code)
      property
    end

    def get_comps(zpid, count=20)
      comps = Rubillow::PropertyDetails.deep_comps(zpid: zpid, count: count)
      error_code = comps.code.to_i
      # For error_code meanings see http://www.zillow.com/howto/api/GetDeepComps.htm
      # (Presence of zpid and count is ensured by Rubillow)
      raise ZillowServiceError, comps.message if (1..4).to_a.include?(error_code)
      raise NoPropertyError, comps.message if error_code.eql? 502
      raise NoEstimateError, comps.message if error_code.eql? 503
      raise NoCompsError, comps.message if error_code.eql? 504
      comps
    end

  end

end
