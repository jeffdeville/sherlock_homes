module SherlockHomes::Scraper
  class Redfin < SherlockHomes::Scraper::Base

    property :page_title, xpath: '/html/head/title'

    property :description, css: '#redfin_search_details_basicinfo_MarketingRemark_0'

    property :stories, css: '#redfin_search_details_basicinfo_MoreInfoRow_0 > td.more-info-data'

    property :property_type, css: '#redfin_search_details_basicinfo_MoreInfoRow_1 > td.more-info-data'

    property :style, css: '#redfin_search_details_basicinfo_MoreInfoRow_2 > td.more-info-data'

    property :year_built, css: '#redfin_search_details_basicinfo_MoreInfoRow_3 > td.more-info-data'

    property :community, css: '#redfin_search_details_basicinfo_MoreInfoRow_4 > td.more-info-data'

    property :country, css: '#redfin_search_details_basicinfo_MoreInfoRow_5 > td.more-info-data > a'

    property :mls, css: '#redfin_search_details_basicinfo_MoreInfoRow_6 > td.more-info-data'

    property :basic_info, css: '#redfin_search_details_PublicRecordsPanel_0' do |node_set|
      BasicInfoParser.parse(node_set)
    end

    property :property_details, css: '#redfin_search_details_amenities_PropertyDetailsPanel_0 > div.panel.col12.pd.collapsible' do |node_set|
      PropertyDetailsParser.parse(node_set)
    end

    collection :property_history, css: '#redfin_search_common_elements_BasicTable_1 > tbody > tr' do
      property :date, css: 'td:nth-child(1)'
      property :event, css: 'td:nth-child(2) > div.event'
      property :price, css: 'td:nth-child(3)'
      property :appreciation, css: 'td:nth-child(4)'
      property :source, css: 'td:nth-child(5)'
    end

    property :walk_score, css: '#redfin_search_details_neighborhood_NeighborhoodStatsPanel_0 > div.main-content > div:nth-child(3) > div > div > div.viz-container > div > div.content > div.percentage'

    property :chart, css: '#redfin_search_details_neighborhood_NeighborhoodStatsChart_0 > div > img' do |node|
      "https://www.redfin.com/#{node.attribute('src')}" if node.respond_to?(:attribute)
    end

    private

    class BasicInfoParser

      def self.parse(node_set)
        new(node_set).parse
      end

      def initialize(root)
        @root = root
      end

      def parse
        results = {}
        @root.css('tr').each do |node|
          text = node.css('td:nth-child(1)').text.strip
          case text
          when 'Beds'
            results[:beds] = node.css('td:nth-child(2)').text.strip
          when 'Baths'
            results[:baths] = node.css('td:nth-child(2)').text.strip
          when 'Floors'
            results[:floors] = node.css('td:nth-child(2)').text.strip
          when 'Year Built'
            results[:year_built] = node.css('td:nth-child(2)').text.strip
          when 'Year Renovated'
            results[:year_renovated] = node.css('td:nth-child(2)').text.strip
          when 'Style'
            results[:style] = node.css('td:nth-child(2)').text.strip
          when 'Finished Sq. Ft.'
            results[:finished] = node.css('td:nth-child(2)').text.strip
          when 'Unfinished Sq. Ft.'
            results[:unfinished] = node.css('td:nth-child(2)').text.strip
          when 'Total Sq. Ft.'
            results[:total] = node.css('td:nth-child(2)').text.strip
          when 'Lot Size'
            results[:lot_size] = node.css('td:nth-child(2)').text.strip
          when 'Land'
            results[:land] = node.css('td:nth-child(2)').text.strip
          when 'Additions'
            results[:additions] = node.css('td:nth-child(2)').text.strip
          when 'Total'
            results[:total] = node.css('td:nth-child(2)').text.strip
          when /^Taxes/
            results[:taxes] = node.css('td:nth-child(2)').text.strip
          end
        end
        results
      end

    end

    class PropertyDetailsParser

      def self.parse(node_set)
        new(node_set).parse
      end

      def initialize(root)
        @root = root
      end

      def parse
        results = {}
        @root.css('div.gutter-left.gutter-right.transition-opaque.amenities-content-node > div').children.each do |node|
          case node.css('div.super-group-title').text.strip
          when 'Interior Features'
            results[:interior_features] = parse_interior_features(node)
          when 'Parking / Garage'
            results[:parking_garage] = parse_parking_garage(node)
          when 'Taxes / Assessments'
            results[:taxes_assessments] = parse_taxes_assessments(node)
          when 'Property / Lot Details'
            results[:property_lot_details] = parse_property_lot_details(node)
          when 'Exterior Features, Homeowners Association, School / Neighborhood & Utilities'
            results[:exterior_features] = parse_exterior_features(node)
          when 'Location Details & Misc. Information'
            results[:location_details] = parse_location_details(node)
          end
        end
        results
      end


      private

      def parse_location_details(node_set)
        results = []
        node_set.css('div.super-group-content').children.each do |node|
          result = Hash.new
          case node.css('h4.title').text.strip
          when 'Location Information'
            result[:location_information] = []
            node.css('li').each do |l|
              result[:location_information] << l.text.strip
            end
          when 'Miscellaneous'
            result[:miscellaneous] = []
            node.css('li').each do |l|
              result[:miscellaneous] << l.text.strip
            end
          end
          results << result
        end
        results
      end

      def parse_exterior_features(node_set)
        results = []
        node_set.css('div.super-group-content').children.each do |node|
          result = Hash.new
          case node.css('h4.title').text.strip
          when 'Exterior Features'
            result[:exterior_features] = []
            node.css('li').each do |l|
              result[:exterior_features] << l.text.strip
            end
          when 'Homeowners Association Information'
            result[:homeowners_association_information] = []
            node.css('li').each do |l|
              result[:homeowners_association_information] << l.text.strip
            end
          when 'School Information'
            result[:school_information] = []
            node.css('li').each do |l|
              result[:school_information] << l.text.strip
            end
          when 'Utility Information'
            result[:utility_information] = []
            node.css('li').each do |l|
              result[:utility_information] << l.text.strip
            end
          end
          results << result
        end
        results

      end

      def parse_property_lot_details(node_set)
        results = []
        node_set.css('div.super-group-content').children.each do |node|
          result = Hash.new
          case node.css('h4.title').text.strip
          when 'Lot Information'
            result[:lot_information] = []
            node.css('li').each do |l|
              result[:lot_information] << l.text.strip
            end
          when 'Property Features'
            result[:property_features] = []
            node.css('li').each do |l|
              result[:property_features] << l.text.strip
            end
          when 'Property Information'
            result[:property_information] = []
            node.css('li').each do |l|
              result[:property_information] << l.text.strip
            end
          end
          results << result
        end
        results
      end

      def parse_taxes_assessments(node_set)
        results = []
        node_set.css('div.super-group-content').children.each do |node|
          result = Hash.new
          case node.css('h4.title').text.strip
          when 'Assessments'
            result[:assessments] = []
            node.css('li').each do |l|
              result[:assessments] << l.text.strip
            end
          when 'Tax Information'
            result[:tax_information] = []
            node.css('li').each do |l|
              result[:tax_information] << l.text.strip
            end
          end
          results << result
        end
        results
      end

      def parse_parking_garage(node_set)
        results = []
        node_set.css('div.super-group-content').children.each do |node|
          result = Hash.new
          case node.css('h4.title').text.strip
          when 'Parking Information'
            result[:parking_information] = []
            node.css('li').each do |l|
              result[:parking_information] << l.text.strip
            end
          when 'Garage'
            result[:garage] = []
            node.css('li').each do |l|
              result[:garage] << l.text.strip
            end
          end
          results << result
        end
        results
      end

      def parse_interior_features(node_set)
        results = []
        node_set.css('div.super-group-content').children.each do |node|
          result = Hash.new
          result[:title] = node.css('h4').text.strip
          result[:values] = []
          node.css('li').each do |l|
            result[:values] << l.text.strip
          end
          results << result
        end
        results
      end
    end

  end
end
