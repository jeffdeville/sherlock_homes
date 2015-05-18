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

    class AbstractParser
      def self.parse(data)
        new(data).parse
      end

      def initialize(data)
        @data = data
      end

      def parse
      end
    end

    class ImageUrlParser < AbstractParser
      def parse
        element = @data.first
        style = element.attributes['style'].value
        /background-image:url\('(.*)'\);/.match(style)[1]
      end
    end

    class SummaryParser < AbstractParser
      def parse
        result = []
        @data.css('li').each do |li|
          result << li.text.strip
        end
        result.delete("Edit Home Facts")
        result
      end
    end

    class PublicRecordsParser < AbstractParser
      def parse
        result = []
        @data.css('li').each do |group|
          group.css('ul > li').each do |li|
            result << li.text.strip
          end
        end
        result
      end
    end

    class PriceHistoryParser < AbstractParser
      def parse
        results = []
        @data.css('.rowHover').each_with_index do |item, index|
          result = {
            date: item.css('td:nth-child(1)').text.strip,
            event: item.css('td:nth-child(2)').text.gsub('view detail', '').strip,
            price: item.css('td:nth-child(3)').text.strip,
            source: item.css('td:nth-child(4) span').first.text.strip,
            agents: item.css('td:nth-child(5)').text.strip,
            detail: {}
          }
          @data.css("#property_deed_#{index+1} > td > ul > li").each do |li|
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
