require 'spec_helper'

RSpec.describe SherlockHomes::Normalizer do

  subject { SherlockHomes::Normalizer.new(redfin: redfin, trulia: trulia, zillow: zillow) }

  describe '#normalize' do
    Given(:redfin) do
      SherlockHomes::Property.new(
        year_built: 1948,
        house_sqft: 2969,
        lot_sqft: 328878,
        floors: 3,
        bedrooms: 4,
        partial_bathrooms: 2,
        full_bathrooms: 2,
        interior_features: %w(Fireplace Cooling),
        total_rooms: 6
      )
    end

    Given(:zillow) do
      SherlockHomes::Property.new(
        year_built: 1948,
        property_type: 'SingleFamily',
        house_sqft: 2969,
        lot_sqft: 155328,
        bedrooms: 3,
        total_rooms: 5
      )
    end

    Given(:trulia) do
      SherlockHomes::Property.new(
        year_built: 1948,
        floors: 3,
        house_sqft: 2969,
        bedrooms: 3,
        partial_bathrooms: 1,
        full_bathrooms: 2,
        total_rooms: 5
      )
    end

    When(:property) { subject.normalize }

    Then { property.is_a? SherlockHomes::Property }

    And  { property.property_type.eql? zillow.property_type }
    And  { property.sources[:property_type].eql? :zillow }
    And  { property.differences[:property_type].nil? }

    And  { property.year_built.eql? zillow.year_built }
    And  { property.sources[:year_built].eql? :zillow }
    And  { property.differences[:year_built].nil? }

    And  { property.floors.eql? redfin.floors }
    And  { property.sources[:floors].eql? :redfin }
    And  { property.differences[:floors].nil? }

    And  { property.house_sqft.eql? redfin.house_sqft }
    And  { property.sources[:house_sqft].eql? :redfin }
    And  { property.differences[:house_sqft].nil? }

    And  { property.bedrooms.eql? redfin.bedrooms }
    And  { property.sources[:bedrooms].eql? :redfin }
    And  { property.differences[:bedrooms].eql?({redfin: 4, zillow: 3, trulia: 3}) }

    And  { property.lot_sqft.eql? redfin.lot_sqft }
    And  { property.sources[:lot_sqft].eql? :redfin }
    And  { property.differences[:lot_sqft].eql?({redfin: 328878, zillow: 155328, trulia: nil}) }

    And  { property.partial_bathrooms.eql? redfin.partial_bathrooms }
    And  { property.sources[:partial_bathrooms].eql? :redfin }
    And  { property.differences[:partial_bathrooms].eql?({redfin: 2, zillow: nil, trulia: 1}) }

    And  { property.full_bathrooms.eql? redfin.full_bathrooms }
    And  { property.sources[:full_bathrooms].eql? :redfin }
    And  { property.differences[:full_bathrooms].nil? }

    And  { property.total_rooms.eql? redfin.total_rooms }
    And  { property.sources[:total_rooms].eql? :redfin }
    And  { property.differences[:total_rooms].eql?({redfin: 6, zillow: 5, trulia: 5}) }

    And  { property.interior_features.eql? redfin.interior_features }
    And  { property.sources[:interior_features].eql? :redfin }
    And  { property.differences[:interior_features].nil? }

  end

end
