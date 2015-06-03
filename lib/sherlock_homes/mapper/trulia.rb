module SherlockHomes
  class Mapper::Trulia < Mapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_public_records
      # TODO invoke methods to map other groups of data
      mapper.property
    end

    def map_public_records
      stories = raw_property.public_records[:stories]
      stories ||= raw_property.public_records[:story]
      property.floors = /[[:digit:]]*/.match(stories).to_s.to_i

      bedrooms = raw_property.public_records[:bedrooms]
      bedrooms ||= raw_property.public_records[:bedroom]
      property.bedrooms = bedrooms

      rooms = raw_property.public_records[:rooms]
      rooms ||= raw_property.public_records[:room]
      property.total_rooms = rooms

      map_bathroom_info

      #TODO to be continued ...
    end

    def map_bathroom_info
      %i(bathrooms bathroom).each do |bath|
        value = raw_property.public_records[bath]
        next if value.nil?
        match_data = /(.*)Partial/.match(value)
        if match_data
          property.partial_bathrooms = match_data[1].strip
        else
          property.full_bathrooms = value
        end
      end
    end

  end

end
