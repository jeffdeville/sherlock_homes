require 'spec_helper'

RSpec.describe SherlockHomes::Pipeline, skip_ci: true do

  subject do
    SherlockHomes::Pipeline.new(raw_location: raw_location)
  end

  Given(:raw_location) { '2490 Riverbend Road, Allentown, PA' }
  When(:ran_pipeline) { subject.run }
  Then { ran_pipeline.context.location.is_a? Geocoder::Result::Google }
  And  { ran_pipeline.context.raw_property.is_a? Hash }
  And  { ran_pipeline.context.raw_property[:zillow].is_a? Rubillow::Models::DeepSearchResult }
  And  { ran_pipeline.context.raw_property[:redfin].is_a? SherlockHomes::Redfin }
  And  { ran_pipeline.context.raw_property[:trulia].is_a? SherlockHomes::Trulia }
  And  { ran_pipeline.context.property.is_a? SherlockHomes::Property }

end
