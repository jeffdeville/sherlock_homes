require 'spec_helper'

RSpec.describe SherlockHomes::Locator, vcr: true do

  describe '#search' do

    context 'with a valid address' do
      Given(:address) { '2114 Bigelow Ave, Seattle, WA' }
      When(:result) { subject.class.search(address) }
      Then { result.is_a? Geocoder::Result::Google }
      And { result.state_code.eql? 'WA' }
      And { result.city.eql? 'Seattle' }
      And { result.route.eql? 'Bigelow Avenue North' }
      And { result.street_number.eql? '2114' }
    end

    context 'with ambiguous address' do
      Given(:address) { 'C.I.A. general headquarters' }
      When(:result) { subject.class.search(address) }
      Then { expect(result).to have_failed(SherlockHomes::Locator::MultipleLocationError)  }
    end

    context 'with a invalid address' do
      Given(:address) { 'this address not exist' }
      When(:result) { subject.class.search(address) }
      Then { expect(result).to have_failed(SherlockHomes::Locator::MissingLocationError)  }
    end

  end

end
