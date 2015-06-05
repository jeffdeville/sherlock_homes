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
        total_rooms: 6,

        interior_features: [
          'Cooling: Zoned Cooling',
          'Fireplace Location: Family Room, Living Room',
          'Technology: Cable, Security System'
        ],
        property_information: [
          'APN: 548580295557-1',
          'Residential'
        ],
        exterior_features: [
          'Roof: Slate',
          'Patio, Porch'
        ],
        homeowners_association_information: [
          'Condo HOA Fee: $0'
        ],
        school_information: [
          'East Penn',
          'High School: Emmaus'
        ],
        utility_information: [
          'Water: Well',
          'Sewer: Septic'
        ],
        location_information: [
          'Lower Macungie',
          'Zoning Code: S'
        ],

        taxable_land: 102400,
        taxable_additions: 265100,
        taxable_total: 367500,
        taxes: 7624
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

    And  { property.interior_features.eql? redfin.interior_features }
    And  { property.sources[:interior_features].eql? :redfin }
    And  { property.differences[:interior_features].nil? }

    And  { property.interior_features.eql? redfin.interior_features }
    And  { property.sources[:interior_features].eql? :redfin }
    And  { property.differences[:interior_features].nil? }

    And  { property.property_information.eql? redfin.property_information }
    And  { property.sources[:property_information].eql? :redfin }
    And  { property.differences[:property_information].nil? }

    And  { property.exterior_features.eql? redfin.exterior_features }
    And  { property.sources[:exterior_features].eql? :redfin }
    And  { property.differences[:exterior_features].nil? }

    And  { property.homeowners_association_information.eql? redfin.homeowners_association_information }
    And  { property.sources[:homeowners_association_information].eql? :redfin }
    And  { property.differences[:homeowners_association_information].nil? }

    And  { property.school_information.eql? redfin.school_information }
    And  { property.sources[:school_information].eql? :redfin }
    And  { property.differences[:school_information].nil? }

    And  { property.utility_information.eql? redfin.utility_information }
    And  { property.sources[:utility_information].eql? :redfin }
    And  { property.differences[:utility_information].nil? }

    And  { property.location_information.eql? redfin.location_information }
    And  { property.sources[:location_information].eql? :redfin }
    And  { property.differences[:location_information].nil? }

    And  { property.taxable_land.eql? redfin.taxable_land }
    And  { property.sources[:taxable_land].eql? :redfin }
    And  { property.differences[:taxable_land].nil? }

    And  { property.taxable_additions.eql? redfin.taxable_additions }
    And  { property.sources[:taxable_additions].eql? :redfin }
    And  { property.differences[:taxable_additions].nil? }

    And  { property.taxable_total.eql? redfin.taxable_total }
    And  { property.sources[:taxable_total].eql? :redfin }
    And  { property.differences[:taxable_total].nil? }

    And  { property.taxes.eql? redfin.taxes }
    And  { property.sources[:taxes].eql? :redfin }
    And  { property.differences[:taxes].nil? }

  end

end
