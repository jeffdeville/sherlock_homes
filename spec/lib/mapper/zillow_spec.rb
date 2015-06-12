require 'spec_helper'

RSpec.describe SherlockHomes::Mapper::Zillow do

  subject { SherlockHomes::Mapper::Zillow }

  describe '#map' do

    Given(:raw_property) do
      double(
        use_code: 'SingleFamily',
        year_built: '1948',
        finished_square_feet: '3470',
        lot_size_square_feet: '4680',
        bedrooms: '3',
        total_rooms: '5',

        last_updated: Date.today,
        change: "-7187",
        change_duration: "30",
        price: "1379674",
        valuation_range: {
          low: "1283097",
          high: "1462454",
        },
        percentile: "0"
      )
    end

    When(:property) { subject.map(raw_property) }

    Then { property.is_a? SherlockHomes::Property }
    And  { property.property_type.eql? 'SingleFamily' }
    And  { property.year_built.eql? 1948 }
    And  { property.house_sqft.eql? 3470 }
    And  { property.lot_sqft.eql? 4680 }
    And  { property.bedrooms.eql? 3 }
    And  { property.total_rooms.eql? 5 }

    And  { property.estimate.is_a? SherlockHomes::Property::Estimate }
    And  { property.estimate.last_updated.eql? raw_property.last_updated }
    And  { property.estimate.value_change.eql? raw_property.change.to_i }
    And  { property.estimate.value_change_duration.eql? raw_property.change_duration.to_i }
    And  { property.estimate.valuation.eql? raw_property.price.to_i }
    And  { property.estimate.percentile.eql? raw_property.percentile.to_i }
    And  { property.estimate.valuation_range_low.eql? raw_property.valuation_range[:low].to_i }
    And  { property.estimate.valuation_range_hi.eql? raw_property.valuation_range[:high].to_i }
  end
end
