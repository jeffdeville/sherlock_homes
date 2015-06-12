module SherlockHomes
  class Mapper::Trulia < Mapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_features
      # TODO invoke methods to map other groups of data
      mapper.property
    end

    def map_features
      property.year_built = pick_feature([:built_in])

      sqft = pick_feature([:sqft])
      property.house_sqft = sqft.delete(',') if sqft

      stories = pick_feature([:stories])
      property.floors = /[[:digit:]]*/.match(stories).to_s.to_i if stories

      property.bedrooms = pick_feature([:bedrooms, :bedroom])
      property.total_rooms = pick_feature([:rooms, :room])

      map_bathroom_info

      #TODO to be continued ...
    end

    private

    # Search raw_property.features for keys in the order given.
    # If an Array is found, returns the first element
    def pick_feature(keys)
      result = nil
      keys.each do |key|
        feature = raw_property.features[key]
        next unless feature
        result ||= feature.is_a?(Array) ? feature.first : feature
        break if result
      end
      result
    end

    def map_bathroom_info
      %i(bathrooms bathroom).each do |bath|
        value = pick_feature([bath])
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
