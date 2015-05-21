require 'spec_helper'

RSpec.describe SherlockHomes::Trulia, sauce: true do

  Given(:scraper) do
    subject.base_url 'http://www.trulia.com/homes/Pennsylvania/Allentown/sold/1263178-2490-Riverbend-Rd-Allentown-PA-18103'
    subject
  end

  When(:result) { scraper.crawl }

  Then { result.page_title.eql?('2490 Riverbend Road, Allentown, PA | Trulia.com') }
  And  { result.image_url.eql?('http://thumbs.trulia-cdn.com/pictures/thumbs_5/ps.71/a/0/e/f/picture-uh=19d9779cfdc0fbf4f6cab4ebfb20c73e-ps=a0efb56dc3f0a2839c2a7e7f7d1237ae-2490-Riverbend-Rd-Allentown-PA-18103.jpg') }

  And  { result.summary.is_a? Hash }
  And  { result.summary[:bedrooms].eql? '3' }
  And  { result.summary[:built_in].eql? '1875' }
  And  { result.summary[:lot_size].eql? '0.9 acres' }
  And  { result.summary[:sqft].eql? '2,563' }
  And  { not result.summary.values.include?('Edit Home Facts') }

  And  { result.description.include?('This is a Single-Family Home located at 2490 Riverbend Road') }

  And  { result.public_records.is_a? Hash }
  And  { result.public_records[:partial_bathroom].eql? '1' }
  And  { result.public_records[:built_in].eql? '1875' }
  And  { result.public_records[:heating].eql? 'Central' }
  And  { result.public_records[:exterior_walls].eql? 'Brick' }
  And  { result.public_records[:basement].eql? 'Full Basement' }
  And  { result.public_records[:bedrooms].eql? '3' }
  And  { result.public_records[:sqft].eql? '2,563' }
  And  { result.public_records[:stories].eql? '3 story with basement' }
  And  { result.public_records[:parking].eql? 'Detached Garage' }
  And  { result.public_records[:rooms].eql? '8' }
  And  { result.public_records[:fireplace].eql? '' }
  And  { result.public_records[:bathrooms].eql? '2' }
  And  { result.public_records[:lot_size].eql? '0.9 acres' }
  And  { result.public_records[:a_c].eql? 'Central' }
  And  { result.public_records[:parking_spaces].eql? '2' }
  And  { result.public_records[:unit].eql? '1' }
  And  { result.public_records[:county].eql? 'Lehigh' }

  And  { result.taxes_assessments.is_a? Array }
  And  { result.taxes_assessments[0][:year].eql?('2014') }
  And  { result.taxes_assessments[0][:assessment].include?('$238,700') }

  And  { result.price_history.is_a? Array }
  And  { result.price_history.last[:date].eql?('05/06/2011') }
  And  { result.price_history.last[:event].eql?('Sold') }
  And  { result.price_history.last[:price].eql?('$265,000') }
  And  { result.price_history.last[:source].eql?('Public records') }
  And  { result.price_history.last[:detail].is_a? Hash }
  And  { result.price_history.last[:detail]["Recording Date"].eql?("05/06/2011") }
  And  { result.price_history.last[:detail]["Sale Price"].eql?("$265,000") }

  And  { result.estimates.is_a? Array }
  And  { result.estimates[0][:property_type].eql?('Single-Family Home') }
  And  { result.estimates[0][:bed].eql?('6') }

end
