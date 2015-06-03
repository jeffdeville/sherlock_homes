require 'spec_helper'

RSpec.describe SherlockHomes::Mapper::Trulia do

  subject { SherlockHomes::Mapper::Trulia }

  describe '#map' do

    Given(:raw_property) do
      double(
        public_records: {
          bathrooms: '2',
          bathroom: '1 Partial',
          bedrooms: '3',
          rooms: '8'
        }
      )
    end

    When(:property) { subject.map(raw_property) }

    Then { property.is_a? SherlockHomes::Property }
    And  { property.bedrooms.eql? 3 }
    And  { property.full_bathrooms.eql? 2 }
    And  { property.partial_bathrooms.eql? 1 }
    And  { property.total_rooms.eql? 8 }

  end
end
