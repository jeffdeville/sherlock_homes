module SherlockHomes
  class RedfinMapper < Mapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_property_details
      mapper.extract_from_property_details
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
              property.send("#{extractor[:attr]}=", match_data[1].strip)
              break
            end
          end
        end
      end
    end

    def map_property_details
      property.interior_features = raw_property.property_details[:interior_features]
      #TODO continue with other mappings
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
        ]
      }
    end

  end
end
