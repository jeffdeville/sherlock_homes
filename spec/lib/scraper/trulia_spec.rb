require 'spec_helper'

RSpec.describe SherlockHomes::Scraper::Trulia do

  Given(:scraper) do
    subject.base_url 'http://www.trulia.com/homes/Pennsylvania/Allentown/sold/1263178-2490-Riverbend-Rd-Allentown-PA-18103'
    subject
  end

  When(:result) { scraper.crawl }

  Then { result.page_title.eql?('2490 Riverbend Road, Allentown, PA | Trulia.com') }
  And  { result.image_url.eql?('http://thumbs.trulia-cdn.com/pictures/thumbs_5/ps.71/a/0/e/f/picture-uh=19d9779cfdc0fbf4f6cab4ebfb20c73e-ps=a0efb56dc3f0a2839c2a7e7f7d1237ae-2490-Riverbend-Rd-Allentown-PA-18103.jpg') }

  And  { result.summary.include?('Single-Family Home') }
  And  { not result.summary.include?('Edit Home Facts') }

  And  { result.description.include?('This is a Single-Family Home located at 2490 Riverbend Road') }

  And  { result.public_records.include?('Single Family Residential') }
  And  { result.public_records.include?('Parking: Detached Garage') }
  And  { result.public_records.include?('County: Lehigh') }

  And  { result.taxes_assessments.is_a? Array }
  And  { result.taxes_assessments[0][:year].eql?('2014') }
  And  { result.taxes_assessments[0][:assessment].include?('$238,700') }

  And  { result.price_history.is_a? Array }
  And  { result.price_history[0][:date].eql?('05/01/2015') }
  And  { result.price_history[0][:event].eql?('Sold') }
  And  { result.price_history[0][:price].eql?('$1,697') }
  And  { result.price_history[0][:source].eql?('Public records') }
  And  { result.price_history[0][:detail].is_a? Hash }
  And  { result.price_history[0][:detail]["Recording Date"].eql?("05/01/2015") }
  And  { result.price_history[0][:detail]["Sale Price"].eql?("$1,697") }

  And  { result.estimates.is_a? Array }
end
