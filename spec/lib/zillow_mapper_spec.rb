require 'spec_helper'

RSpec.describe SherlockHomes::ZillowMapper do

  subject { SherlockHomes::ZillowMapper }

  describe '#map' do

    Given(:raw_property) do
      double(
        use_code: 'SingleFamily',
        bedrooms: '3',
        total_rooms: '5'
      )
    end

    When(:property) { subject.map(raw_property) }

    Then { property.is_a? SherlockHomes::Property }
    And  { property.property_type.eql? 'SingleFamily' }
    And  { property.bedrooms.eql? 3 }
    And  { property.total_rooms.eql? 5 }

  end
end
