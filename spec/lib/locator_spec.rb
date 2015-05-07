require 'spec_helper'

RSpec.describe SherlockHomes::Locator, vcr: true do

  describe '#search' do

    context 'with a valid address' do
      Given(:address) { '2114 Bigelow Ave, Seattle, WA' }
      When(:result) { subject.class.search(address) }
      Then { result.is_a? Array }
      And { result.eql? [47.637923, -122.3481375] }
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
