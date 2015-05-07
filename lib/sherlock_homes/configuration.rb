module SherlockHomes
  class Configuration
    attr_accessor :zillow_key

    def initialize
      @zillow_key = ENV["ZILLOW_KEY"]
    end
  end

end
