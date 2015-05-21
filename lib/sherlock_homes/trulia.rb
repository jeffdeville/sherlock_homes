module SherlockHomes
  class Trulia
    include Yasf::Crawler

    property :page_title, xpath: '/html/head/title'

    property :image_url, css: '#x-id-1 > div' do |node_set|
      ImageUrlParser.parse(node_set)
    end

    property :summary, css: '#propertyDetails > div.col.cols16 > ul' do |ul|
      SummaryParser.parse(ul)
    end

    property :description, css: '#corepropertydescription' do |node_set|
      node_set.first.text.strip
    end

    property :public_records, css: 'body > section > div:nth-child(1) > div > div.line.asideFloaterContainer > div > div.mtl > ul' do |ul|
      PublicRecordsParser.parse(ul)
    end

    collection :taxes_assessments, css: 'body > section > div:nth-child(1) > div > div:nth-child(5) > div > div.mtl > table > tbody > tr' do
      property :year, css: 'td:nth-child(1)', strip: true
      property :tax, css: 'td:nth-child(2)', strip: true
      property :assessment, css: 'td:nth-child(4)', strip: true
      property :market, css: 'td:nth-child(5)', strip: true
    end

    property :price_history, css: 'body > section > div:nth-child(1) > div > div:nth-child(5) > div > div.mts > table > tbody > tr' do |node_set|
      PriceHistoryParser.parse(node_set)
    end

    collection :estimates, css: '#nearby_container > table > tbody > tr' do
      property :address, css: 'td:nth-child(1)', strip: true
      property :property_type, css: 'td:nth-child(2)', strip: true
      property :bed, css: 'td:nth-child(3)', strip: true
      property :bath, css: 'td:nth-child(4)', strip: true
      property :sqft, css: 'td:nth-child(5)', strip: true
    end

    private

    module ImageUrlParser
      def self.parse(data)
        element = data.first
        style = element.attributes['style'].value
        /background-image:url\('(.*)'\);/.match(style)[1]
      end
    end

    module SummaryParser
      def self.parse(data)
        result = Hash.new
        data.css('li').each do |li|
          text = li.text.strip
          next if text.eql? "Edit Home Facts"
          result.merge! BulletItemParser.parse(text)
        end
        result
      end
    end

    module PublicRecordsParser
      def self.parse(data)
        result = Hash.new
        data.css('li').each do |group|
          group.css('ul > li').each do |li|
            result.merge! BulletItemParser.parse(li.text.strip)
          end
        end
        result
      end
    end

    module BulletItemParser
      def self.parse(data)
        key = 'unknown'
        value = nil
        sep = ':'
        patterns = [
          'partial bathrooms', 'partial bathroom', 'bathrooms', 'bathroom',
          'bedrooms', 'bedroom', 'rooms', 'room', 'built in', 'sqft',
          'fireplace', 'units', 'unit'
        ]
        underscorize = ->(str) { str.gsub(/[^\w]/, '_') }
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
        {underscorize.call(key).to_sym => value}
      end
    end

    module PriceHistoryParser
      def self.parse(data)
        results = []
        data.css('.rowHover').each_with_index do |item, index|
          result = {
            date: item.css('td:nth-child(1)').text.strip,
            event: item.css('td:nth-child(2)').text.gsub('view detail', '').strip,
            price: item.css('td:nth-child(3)').text.strip,
            source: item.css('td:nth-child(4) span').first.text.strip,
            agents: item.css('td:nth-child(5)').text.strip,
            detail: {}
          }
          data.css("#property_deed_#{index+1} > td > ul > li").each do |li|
            key = li.css('.col.cols7.pls').text.strip
            value = li.css('.col.lastCol.pln').text.strip
            result[:detail][key] = value
          end
          results << result
        end
        results
      end
    end

  end
end
