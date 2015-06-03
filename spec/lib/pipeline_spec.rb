require 'spec_helper'

RSpec.describe SherlockHomes::Pipeline, skip_ci: true do

  subject do
    SherlockHomes::Pipeline.new(raw_location: raw_location)
  end

  Given(:raw_location) { '2490 Riverbend Road, Allentown, PA' }
  When(:ran_pipeline) { subject.run }
  Then { ran_pipeline.context.location.is_a? Geocoder::Result::Google }
  And  { ran_pipeline.context.raw_zillow.is_a? Rubillow::Models::DeepSearchResult }
  And  { ran_pipeline.context.raw_redfin.is_a? SherlockHomes::Scraper::Redfin }
  And  { ran_pipeline.context.raw_trulia.is_a? SherlockHomes::Scraper::Trulia }
  And  { ran_pipeline.context.redfin.is_a? SherlockHomes::Property }
  And  { ran_pipeline.context.zillow.is_a? SherlockHomes::Property }
  And  { ran_pipeline.context.trulia.is_a? SherlockHomes::Property }
  And  { ran_pipeline.context.property.is_a? SherlockHomes::Property }

end
