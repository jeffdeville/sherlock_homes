module SherlockHomes
  class Trulia < SitePrism::Page

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

    def public_records
      @public_records ||= Hash.new.tap do |result|
        all('div.mtl ul.listBulleted > li').each do |pr|
          result.merge! parse(pr.text)
        end
      end
    end

    private

    def parse(data)
      key = 'unknown'
      value = nil
      sep = ':'

      patterns = [
        'partial bathrooms', 'partial bathroom', 'bathrooms', 'bathroom',
        'bedrooms', 'bedroom', 'rooms', 'room', 'built in', 'sqft',
        'fireplace', 'units', 'unit'
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
        value ||= data
      end
      key.gsub!(/[^\w]/, '_')
      { key.titleize.delete(' ').underscore.to_sym => value }
    end

  end
end
