module SherlockHomes::Scraper
  class Base
    include Yasf::Crawler

    def self.namespace
      self.to_s.split("::").last.downcase
    end

    protected

    def self.inherited(klass)
      super
      SherlockHomes::Scraper.register_scraper(name: klass.namespace, class: klass)
    end

  end
end
