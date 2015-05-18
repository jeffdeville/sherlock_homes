require 'spec_helper'

describe SherlockHomes::Zillow, :vcr do

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

  describe '#get_comps' do
    Given(:zpid) { 48749425 }
    Given(:count) { 10 }
    When(:comps) { subject.get_comps(zpid: zpid, count: count) }

    context 'when comps exist for that property' do
      Then { comps.principal.zpid.to_i.eql?(zpid) }
      Then { comps.comparables.keys.count <= count }
      Then { not comps.comparables.values.first.zpid.nil? }
    end

    context 'when no property exists for the given zpid' do
      Given(:zpid) { 99999999 }
      Then { expect(comps).to have_failed(SherlockHomes::NoPropertyError) }
    end

    context 'when no zpid is provided' do
      Given(:zpid) { nil }
      Then { expect(comps).to have_failed(ArgumentError) }
    end

    context 'when no count is provided' do
      Given(:count) { nil }
      Then { expect(comps).to have_failed(ArgumentError) }
    end
  end

end
