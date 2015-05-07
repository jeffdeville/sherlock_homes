require 'spec_helper'

describe SherlockHomes::PropertyFinder, :vcr do

  describe '#search' do
    When(:property) { subject.search(address: address, citystatezip: citystatezip) }

    context 'when a property exists for that address' do
      Given(:address) { "2114 Bigelow Ave" }
      Given(:citystatezip) { "Seattle, WA" }
      Then { not property.zpid.nil? }
      And { property.address[:city].eql? 'Seattle' }
      And { property.address[:state].eql? 'WA' }
    end

    context 'when wrong citystatezip is provided' do
      Given(:address) { "2114 Bigelow Ave" }
      Given(:citystatezip) { "Seattle, CO" }
      Then { expect(property).to have_failed(SherlockHomes::AddressResolveError) }
    end

    context 'when no citystatezip is provided' do
      Given(:address) {"2114 Bigelow Ave" }
      Given(:citystatezip) { nil }
      Then { expect(property).to have_failed(ArgumentError) }
    end

    context 'when no address is provided' do
      Given(:address) { nil }
      Given(:citystatezip) { "Seattle, WA" }
      Then { expect(property).to have_failed(ArgumentError) }
    end
  end

end
