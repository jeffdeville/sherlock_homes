module SherlockHomes
  class Locator
    class MissingLocationError < StandardError; end
    class MultipleLocationError < StandardError; end

    EMPTY = 0
    FOUND = 1

    ##
    # Search coordinates about an address.
    #
    def self.search(address, options = {})
      results = Geocoder.search(address, options)
      case results.count
      when FOUND
        results.first
      when EMPTY
        raise MissingLocationError.new address
      else
        raise MultipleLocationError.new address
      end
    end

  end
end
