module SherlockHomes
  class Mapper::Zillow < Mapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_basic_info
      # TODO invoke methods to map other groups of data
      mapper.property
    end

    def map_basic_info
      property.property_type = raw_property.use_code
      property.year_built = raw_property.year_built
      property.house_sqft = raw_property.finished_square_feet
      property.lot_sqft = raw_property.lot_size_square_feet
      property.bedrooms = raw_property.bedrooms
      property.total_rooms = raw_property.total_rooms
    end

  end
end
