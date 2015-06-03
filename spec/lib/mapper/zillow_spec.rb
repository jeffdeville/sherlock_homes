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
        total_rooms: '5'
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

  end
end
