require 'spec_helper'

RSpec.describe SherlockHomes::Trulia do

  When do
    subject.class.set_url 'http://www.trulia.com/homes/Pennsylvania/Allentown/sold/1263178-2490-Riverbend-Rd-Allentown-PA-18103'
    subject.load
    subject.wait_for_estimates
  end

  Then { subject.title.eql?('2490 Riverbend Road, Allentown, PA | Trulia.com') }
  And  { subject.image['src'].include?('2490-Riverbend-Rd-Allentown-PA-18103.jpg') }

  # Public Records
  And  { subject.public_records.is_a? Hash }
  And  { subject.public_records[:partial_bathroom].eql? '1' }
  And  { subject.public_records[:built_in].eql? '1875' }
  And  { subject.public_records[:heating].eql? 'Central' }
  And  { subject.public_records[:exterior_walls].eql? 'Brick' }
  And  { subject.public_records[:basement].eql? 'Full Basement' }
  And  { subject.public_records[:bedrooms].eql? '3' }
  And  { subject.public_records[:sqft].eql? '2,563' }
  And  { subject.public_records[:stories].eql? '3 story with basement' }
  And  { subject.public_records[:parking].eql? 'Detached Garage' }
  And  { subject.public_records[:rooms].eql? '8' }
  And  { subject.public_records[:fireplace].eql? '' }
  And  { subject.public_records[:bathrooms].eql? '2' }
  And  { subject.public_records[:lot_size].eql? '0.9 acres' }
  And  { subject.public_records[:ac].eql? 'Central' }
  And  { subject.public_records[:parking_spaces].eql? '2' }
  And  { subject.public_records[:unit].eql? '1' }
  And  { subject.public_records[:county].eql? 'Lehigh' }

  # Taxes and Assessment
  And  { subject.taxes_assessments.is_a? Array }
  And  { subject.taxes_assessments.last.year.text.eql?('2014') }
  And  { subject.taxes_assessments.last.assessment.text.include?('$238,700') }

  And  { subject.description.text.include?('This is a Single-Family Home located at 2490 Riverbend Road') }

  # Price_history
  And  { subject.price_history.is_a? Array }
  And  { subject.price_history.last.date.text.eql?('05/06/2011') }
  And  { subject.price_history.last.event.text.eql?('Sold view detail') }
  And  { subject.price_history.last.price.text.eql?('$265,000') }
  And  { subject.price_history.last.source.text.eql?('Public records') }
  And  { subject.price_history.last.details.is_a? OpenStruct }
  And  { subject.price_history.last.details.recording_date.eql?("05/06/2011") }
  And  { subject.price_history.last.details.sale_price.eql?("$265,000") }

  # Estimates
  And  { subject.estimates.is_a? Array }
  And  { subject.estimates.last.property_type.text.eql?('Single-Family Home') }
  And  { subject.estimates.last.bed.text.eql?('6') }

end
