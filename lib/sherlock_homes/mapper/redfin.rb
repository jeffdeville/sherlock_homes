module SherlockHomes
  class Mapper::Redfin < Mapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_property_details
      mapper.extract_from_property_details
      mapper.map_basic_info
      mapper.map_tax_info
      # TODO invoke methods to map other groups of data
      mapper.property
    end

    def extract_from_property_details
      extractors_map.each do |key, extractors|
        items = raw_property.property_details[key]
        extractors.each do |extractor|
          items.each do |item|
            match_data = extractor[:regexp].match(item)
            if match_data
              property.send("#{extractor[:attr]}=", "#{match_data[1].strip}#{match_data[2]}")
              break
            end
          end
        end unless items.nil?
      end
    end

    def map_property_details
      property.interior_features = raw_property.property_details[:interior_features]
      property.property_information = raw_property.property_details[:property_information]
      property.exterior_features = raw_property.property_details[:exterior_features]
      property.homeowners_association_information = raw_property.property_details[:homeowners_association_information]
      property.school_information = raw_property.property_details[:school_information]
      property.utility_information = raw_property.property_details[:utility_information]
      property.location_information = raw_property.property_details[:location_information]
      #TODO continue with other mappings
    end

    def map_basic_info
      property.floors = raw_property.basic_info.floors.text
      property.year_built = raw_property.basic_info.year_built.text
      #TODO continue with other mappings
    end

    def map_tax_info
      digits_to_i = lambda { |s| s.gsub(/[^0-9]/, '').to_i }
      property.taxable_land = digits_to_i.call(raw_property.tax_info.land.text)
      property.taxable_additions = digits_to_i.call(raw_property.tax_info.additions.text)
      property.taxable_total = digits_to_i.call(raw_property.tax_info.total.text)
      property.taxes = digits_to_i.call(raw_property.tax_info.taxes.text)
    end

    def map_neighborhood_info
      property.walk_score = neighborhood.walk_score.text
      property.neighborhood_stats_chart = neighborhood.stats_chart['src']
    end


    private

    def extractors_map
      {
        bedroom_information: [
          { attr: :bedrooms, regexp: /Bedroom[s]?:(.*)/ }
        ],
        bathroom_information: [
          { attr: :full_bathrooms, regexp: /# of Bathrooms \(Full\):(.*)/ },
          { attr: :partial_bathrooms, regexp: /# of Bathrooms \(1\/2\):(.*)/ }
        ],
        room_information: [
          { attr: :total_rooms, regexp: /# of Rooms \(Total\):(.*)/ }
        ],
        lot_information: [
          { attr: :lot_sqft, regexp: /Lot Sq. Ft.:([^,]+),?([^,]+),?([^,]*)/ }
        ],
        property_features: [
          { attr: :house_sqft, regexp: /Sq. Ft.:([^,]+),?([^,]+),?([^,]*)/ }
        ]
      }
    end

  end
end
