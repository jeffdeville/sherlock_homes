require 'spec_helper'

RSpec.describe SherlockHomes::RedfinMapper do

  subject { SherlockHomes::RedfinMapper }

  describe '#map' do

    Given(:raw_property) do
      double(
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
          ]
        }
      )
    end

    When(:property) { subject.map(raw_property) }

    Then { property.is_a? SherlockHomes::Property }
    And  { property.bedrooms.eql? 4 }
    And  { property.full_bathrooms.eql? 2 }
    And  { property.partial_bathrooms.eql? 1 }
    And  { property.total_rooms.eql? 14 }

  end
end
