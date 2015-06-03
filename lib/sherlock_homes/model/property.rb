module SherlockHomes
  class Property
    include Virtus.model

    attribute :property_type, String
    attribute :floors, Integer
    attribute :bedrooms, Integer
    attribute :full_bathrooms, Integer
    attribute :partial_bathrooms, Integer
    attribute :total_rooms, Integer
    attribute :interior_features, Array[String]

    # Keeps track of the source for each stored attribute.
    # Example: {bedrooms: 'redfin'}
    attribute :sources, Hash[Symbol => String]

    # Keeps track of the differences for each stored attribute,
    # found in sources different than the chosen one.
    # Example: Assuming that bedrooms==2 and sources[:bedrooms]==:redfin, we could have
    # differences == {bedrooms: {trulia: 1, zillow: 1}}
    attribute :differences, Hash[Symbol => Hash]

  end
end
