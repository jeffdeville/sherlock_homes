module SherlockHomes
  class RedfinMapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_property_details
      # TODO invoke methods to map other groups of data
      mapper.property
    end

    attr_reader :raw_property, :property

    def initialize(_raw_property)
      @raw_property = _raw_property
      @property = Property.new
    end

    def map_property_details
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
