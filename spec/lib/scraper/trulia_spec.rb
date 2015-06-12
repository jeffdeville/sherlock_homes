require 'spec_helper'

RSpec.describe SherlockHomes::Scraper::Trulia, skip_ci: true do

  When do
    url = URI.encode('http://www.trulia.com/submit_search?tst=h&search=2490 Riverbend Road, Allentown, PA 18103, USA')
    subject.class.find url
  end

  Then { subject.title.eql?('2490 Riverbend Road, Allentown, PA | Trulia.com') }
  And  { subject.image['src'].include?('2490-Riverbend-Rd-Allentown-PA-18103.jpg') }

  # Public Records
  And  { subject.features.is_a? Hash }
  And  { subject.features[:bathroom].eql? '1 Partial' }
  And  { subject.features[:built_in].eql? '1875' }
  And  { subject.features[:heating].eql? 'Central' }
  And  { subject.features[:exterior_walls].eql? 'Brick' }
  And  { subject.features[:basement].eql? 'Full Basement' }
  And  { subject.features[:bedrooms].eql? '3' }
  And  { subject.features[:sqft].eql? '2,563' }
  And  { subject.features[:stories].eql? '3 story with basement' }
  And  { subject.features[:parking].eql? 'Detached Garage' }
  And  { subject.features[:rooms].eql? '8' }
  And  { subject.features[:bathrooms].eql? '2' }
  And  { subject.features[:lot_size].eql? '0.9 acres' }
  And  { subject.features[:a_c].eql? 'Central' }
  And  { subject.features[:parking_spaces].eql? '2' }
  And  { subject.features[:unit].eql? '1' }
  And  { subject.features[:county].eql? 'Lehigh' }

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
