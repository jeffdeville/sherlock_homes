module SherlockHomes
  class Scraper::Trulia < Scraper

    def self.find(url)
      restart_phantomjs
      scraper = new
      scraper.class.set_url url
      scraper.load
      scraper.wait_for_estimates
      scraper
    end

    class PriceHistory < SitePrism::Section
      element :date, 'td:nth-child(1)'
      element :event, 'td:nth-child(2)'
      element :price, 'td:nth-child(3)'
      element :source, 'td:nth-child(4) > span.hideVisually'
      element :agents, 'td:nth-child(5)'

      def details
        id = event.find('a')['href'].delete('#')
        @details ||= OpenStruct.new.tap do |details|
          all(:xpath, "//*[@id='#{id}']/td/ul/li").each do |e|
            key = e.find('div:nth-child(1)').text.remove(' ').underscore
            details[key] = e.find('div:nth-child(2)').text
          end
        end
      end
    end

    class TaxesAssessments < SitePrism::Section
      element :year, 'td:nth-child(1)'
      element :tax, 'td:nth-child(2)'
      element :assessment, 'td:nth-child(4)'
      element :market, 'td:nth-child(5)'
    end

    class Estimates < SitePrism::Section
      element :address, 'td:nth-child(1)'
      element :property_type, 'td:nth-child(2)'
      element :bed, 'td:nth-child(3)'
      element :bath, 'td:nth-child(4)'
      element :sqft, 'td:nth-child(5)'
    end

    element :description, '#corepropertydescription'

    element :image, '#mediaTabs > li.photoTabContent.man.tabContent.clickable.openStaticPhotoPlayer > ul > li.man > div > div > a > img'

    sections :price_history, PriceHistory, 'body > section > div:nth-child(1) > div > div:nth-child(5) > div > div.mts > table > tbody > tr.rowHover'

    sections :estimates, Estimates, '#nearby_container > table > tbody > tr'

    sections :taxes_assessments, TaxesAssessments, 'body > section > div:nth-child(1) > div > div:nth-child(5) > div > div.mtl > table > tbody > tr'

    def features
      @features ||= Hash.new.tap do |result|
        all('div.mtl ul.listBulleted > li').each do |pr|
          result.merge!(parse(pr.text)) {|key, oldval, newval| [oldval, newval].flatten}
        end
      end
    end

    private

    def parse(data)
      key = nil
      value = nil
      sep = ':'

      patterns = [
        'bathrooms', 'bathroom', 'bedrooms', 'bedroom', 'rooms', 'room',
        'built in', 'sqft', 'units', 'unit'
      ]

      if data.include? sep
        splitted = data.split(sep)
        key = splitted[0].strip.downcase
        value = splitted[1].strip
      else
        patterns.each do |pattern|
          match_data = data.match(/(.*)#{pattern}(.*)/i)
          if match_data
            key = pattern
            value = "#{match_data[1]} #{match_data[2]}".strip
            break
          end
        end
        rand_number = ('0'..'9').to_a.shuffle[0,5].join
        key ||= "unknown_#{rand_number}"
        value ||= data
      end
      { key.gsub(/[^\w]/, '_').to_sym => value }
    end

  end
end
