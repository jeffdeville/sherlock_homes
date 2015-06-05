module SherlockHomes
  class Property
    include Virtus.model

    # Keeps track of the source for each stored attribute.
    # Example: {bedrooms: 'redfin'}
    attribute :sources, Hash[Symbol => String]

    # Keeps track of the differences for each stored attribute,
    # found in sources different than the chosen one.
    # Example: Assuming that bedrooms==2 and sources[:bedrooms]==:redfin, we could have
    # differences == {bedrooms: {trulia: 1, zillow: 1}}
    attribute :differences, Hash[Symbol => Hash]

    attribute :property_type, String
    attribute :year_built, Integer
    attribute :floors, Integer
    attribute :house_sqft, Integer
    attribute :lot_sqft, Integer
    attribute :bedrooms, Integer
    attribute :full_bathrooms, Integer
    attribute :partial_bathrooms, Integer
    attribute :total_rooms, Integer

    attribute :interior_features, Array[String]
    attribute :property_information, Array[String]
    attribute :exterior_features, Array[String]
    attribute :homeowners_association_information, Array[String]
    attribute :school_information, Array[String]
    attribute :utility_information, Array[String]
    attribute :location_information, Array[String]

    attribute :taxable_land, Integer
    attribute :taxable_additions, Integer
    attribute :taxable_total, Integer
    attribute :taxes, Integer

    attribute :walk_score, Integer
    attribute :neighborhood_stats_chart, String

  end
end
