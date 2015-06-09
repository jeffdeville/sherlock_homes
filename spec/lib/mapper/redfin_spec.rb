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
          parking_information: [
            '# of Cars: 2',
            'Parking: Off Street'
          ],
          garage: [
            'Built-In'
          ],
          interior_features: [
            'Cooling: Zoned Cooling',
            'Fireplace Location: Family Room, Living Room',
            'Technology: Cable, Security System'
          ],
          lot_information: [
            'Private Road, Wooded',
            '5 - 10 Acres',
            'Lot Sq. Ft.: 328,878'
          ],
          property_features: [
            'Acres: 7.55',
            'Sq. Ft.: 2,969'
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
          ]
        },
        tax_info: double(
          land: double(text: '$102,400'),
          additions: double(text: '$265,100'),
          total: double(text: '$367,500'),
          taxes: double(text: '$7,624')
        ),
        neighborhood: double(
          walk_score: double(text: '2'),
          stats_chart: {'src' => '2/6989/MEDIAN_HOUSE_SQ_FT_BY_TIME.png'}
        )
      )
    end

    When(:property) { subject.map(raw_property) }

    Then { property.is_a? SherlockHomes::Property }
    And  { property.year_built.eql? 1948 }
    And  { property.floors.eql? 2 }
    And  { property.house_sqft.eql? 2969 }
    And  { property.lot_sqft.eql? 328878 }
    And  { property.bedrooms.eql? 4 }
    And  { property.full_bathrooms.eql? 2 }
    And  { property.partial_bathrooms.eql? 1 }
    And  { property.total_rooms.eql? 14 }

    And  { property.interior_features.eql? raw_property.property_details[:interior_features] }
    And  { property.property_information.eql? raw_property.property_details[:property_information] }
    And  { property.exterior_features.eql? raw_property.property_details[:exterior_features] }
    And  { property.homeowners_association_information.eql? raw_property.property_details[:homeowners_association_information] }
    And  { property.school_information.eql? raw_property.property_details[:school_information] }
    And  { property.utility_information.eql? raw_property.property_details[:utility_information] }
    And  { property.location_information.eql? raw_property.property_details[:location_information] }

    And  { property.taxable_land.eql? 102400 }
    And  { property.taxable_additions.eql? 265100 }
    And  { property.taxable_total.eql? 367500 }
    And  { property.taxes.eql? 7624 }

    And  { property.walk_score.eql? 2 }
    And  { property.neighborhood_stats_chart.eql? raw_property.neighborhood.stats_chart['src'] }

    And  { property.parking_ncars.eql? 2 }
    And  { property.parking_info.eql? 'Off Street; Garage: Built-In' }

  end
end
