module SherlockHomes

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end

  class Configuration
    attr_accessor :zillow_key

    def zillow_key
      @zillow_key || ENV["ZILLOW_KEY"]
    end
  end

end
