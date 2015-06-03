require 'spec_helper'

RSpec.describe SherlockHomes::Mapper::Redfin do

  subject { SherlockHomes::Mapper::Redfin }

  describe '#map' do

    Given(:raw_property) do
      double(
        basic_info: double(
          floors: double(text: '2'),
          year_built: double(text: '1948')
        ),
        property_details: {
          bedroom_information: [
            'Bedrooms: 4'
          ],
          bathroom_information: [
            'Bathrooms: 3',
            '# of Bathrooms (Full): 2',
            '# of Bathrooms (1/2): 1'
          ],
          room_information: [
            '# of Rooms (Total): 14',
            'Dining Room',
            'Daylight, Partially Finished'
          ],
          interior_features: [
            'Cooling: Zoned Cooling',
            'Fireplace Location: Family Room, Living Room',
            'Technology: Cable, Security System'
          ]
        }
      )
    end

    When(:property) { subject.map(raw_property) }

    Then { property.is_a? SherlockHomes::Property }
    And  { property.year_built.eql? 1948 }
    And  { property.floors.eql? 2 }
    And  { property.bedrooms.eql? 4 }
    And  { property.full_bathrooms.eql? 2 }
    And  { property.partial_bathrooms.eql? 1 }
    And  { property.total_rooms.eql? 14 }
    And  { property.interior_features.eql? raw_property.property_details[:interior_features] }

  end
end
