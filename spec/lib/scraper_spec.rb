require 'spec_helper'

RSpec.describe SherlockHomes::Scraper do

  describe 'respond_to' do
    it { should respond_to(:from_redfin) }
    it { should respond_to(:from_trulia) }
  end

end