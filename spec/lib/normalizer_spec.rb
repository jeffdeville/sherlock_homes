require 'spec_helper'

RSpec.describe SherlockHomes::Normalizer do

  subject { SherlockHomes::Normalizer.new(redfin, trulia, zillow) }

  describe '#normalize' do
    Given(:redfin) do
      SherlockHomes::Property.new(
        bedrooms: 4,
        partial_bathrooms: 2,
        full_bathrooms: 2,
        interior_features: %w(Fireplace Cooling),
        total_rooms: 6
      )
    end

    Given(:zillow) do
      SherlockHomes::Property.new(
        property_type: 'SingleFamily',
        bedrooms: 3,
        total_rooms: 5
      )
    end

    Given(:trulia) do
      SherlockHomes::Property.new(
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

    And  { property.bedrooms.eql? redfin.bedrooms }
    And  { property.sources[:bedrooms].eql? :redfin }
    And  { property.differences[:bedrooms].eql?({redfin: 4, zillow: 3, trulia: 3}) }

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
