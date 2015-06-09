module SherlockHomes
  class Mapper::Zillow < Mapper

    def self.map(raw_property)
      mapper = new(raw_property)
      mapper.map_basic_info
      mapper.map_estimate
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

    def map_estimate
      property.estimate = Property::Estimate.new(
        last_updated: raw_property.last_updated,
        value_change: raw_property.change,
        value_change_duration: raw_property.change_duration,
        valuation: raw_property.price,
        valuation_range_low: raw_property.valuation_range[:low],
        valuation_range_hi: raw_property.valuation_range[:high],
        percentile: raw_property.percentile
      )
    end

  end
end
