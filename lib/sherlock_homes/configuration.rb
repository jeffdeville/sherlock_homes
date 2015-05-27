module SherlockHomes

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end

  class Configuration
    attr_accessor :zillow_key,
                  :driver,
                  :wait_time,
                  :timeout,
                  :debug,
                  :proxy_host,
                  :proxy_port

    def initialize
      @debug      = false
      @driver     = :poltergeist
      @timeout    = 60
      @zillow_key = ENV["ZILLOW_KEY"]
      @wait_time  = 60
      @proxy_host = nil
      @proxy_port = nil
    end

    def debug?
      !!debug
    end

    def proxy?
      proxy_host.present? and proxy_port.present?
    end

  end

end
