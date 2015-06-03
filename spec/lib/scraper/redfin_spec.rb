require 'spec_helper'

RSpec.describe SherlockHomes::Scraper::Redfin, skip_ci: true do
  Given(:property_url) { 'https://www.redfin.com/PA/Allentown/2354-S-Cedar-Crest-Blvd-18103/home/59034427' }

  describe '#find' do
    When do
      subject.class.find property_url
    end

    describe 'main info' do
      Then { subject.title.eql?('2354 S Cedar Crest Blvd, Lower Macungie Twp, PA 18103 | MLS# 486144 | Redfin') }

      # Description
      And { expect(subject.description.text).to_not be_nil }

      # Basic Info
      And  { expect(subject.basic_info.bed.text).to be_eql('4') }
      And  { expect(subject.basic_info.baths.text).to be_eql('2') }
      And  { expect(subject.basic_info.floors.text).to be_eql('2') }
      And  { expect(subject.basic_info.year_built.text).to be_eql('1948') }
      And  { expect(subject.basic_info.year_renovated.text).to be_eql('—') }
      And  { expect(subject.basic_info.style.text).to be_eql('Single Family Residential') }
      And  { expect(subject.basic_info.finished.text).to be_eql('2,969') }
      And  { expect(subject.basic_info.unfinished.text).to be_eql('0') }
      And  { expect(subject.basic_info.total_sqft.text).to be_eql('2,969') }
      And  { expect(subject.basic_info.lot_size.text).to be_eql('156,324') }

      # Tax Info
      And  { expect(subject.tax_info.land.text).to be_eql('$102,400') }
      And  { expect(subject.tax_info.additions.text).to be_eql('$265,100') }
      And  { expect(subject.tax_info.total.text).to be_eql('$367,500') }
      And  { expect(subject.tax_info.taxes.text).to be_eql('$7,624') }

      # History
      And  { expect(subject.history.last.date.text).to be_eql('Oct 18, 2005') }
      And  { expect(subject.history.last.event.text).to be_eql('Listed') }
      And  { expect(subject.history.last.price.text).to be_eql('*') }
      And  { expect(subject.history.last.appreciation.text).to be_eql('—') }
      And  { expect(subject.history.last.source.text).to be_eql('LEHIGHMLS #230456') }

      # Schools
      And  { expect(subject.schools.count).to be_eql(18) }

      And do
        subject.schools.each do |school|
          expect(school).to respond_to(:name)
          expect(school).to respond_to(:type)
          expect(school).to respond_to(:grades)
          expect(school).to respond_to(:distance)
        end
      end

      # Neighborhood
      And  { expect(subject.neighborhood.walk_score.text).to be_eql('2') }
      And  { expect(subject.neighborhood.stats_chart['src']).to include('2/6989/MEDIAN_HOUSE_SQ_FT_BY_TIME.png') }
    end

    context 'property details' do
      Then  { expect(subject.details.count).to be_eql(6) }
      And do
        subject.details.each do |detail|
          expect(detail).to respond_to(:group_title)
          expect(detail).to respond_to(:group_content)

          detail.group_content.each do |gc|
            expect(gc).to respond_to(:title)
            expect(gc).to respond_to(:items)
          end
        end
      end
      And { expect(subject.property_details).to be_a Hash }
      And { expect(subject.property_details[:bedroom_information]).to be_a Array }
      And { expect(subject.property_details[:bathroom_information]).to be_a Array }
      And { expect(subject.property_details[:interior_features]).to be_a Array }
      And { expect(subject.property_details[:room_information]).to be_a Array }
      And { expect(subject.property_details[:parking_information]).to be_a Array }
      And { expect(subject.property_details[:garage]).to be_a Array }
      And { expect(subject.property_details[:assessments]).to be_a Array }
      And { expect(subject.property_details[:tax_information]).to be_a Array }
      And { expect(subject.property_details[:lot_information]).to be_a Array }
      And { expect(subject.property_details[:property_features]).to be_a Array }
      And { expect(subject.property_details[:property_information]).to be_a Array }
      And { expect(subject.property_details[:exterior_features]).to be_a Array }
      And { expect(subject.property_details[:homeowners_association_information]).to be_a Array }
      And { expect(subject.property_details[:school_information]).to be_a Array }
      And { expect(subject.property_details[:utility_information]).to be_a Array }
      And { expect(subject.property_details[:location_information]).to be_a Array }
    end
  end

  describe '#property_url_from' do
    Given(:formatted_address) { '2354 South Cedar Crest Boulevard, Allentown, PA 18103, USA' }
    Given(:search_url) { URI.encode("https://www.redfin.com/stingray/do/query-location?v=1&location=#{formatted_address}") }
    When(:result_url) { subject.class.property_url_from(search_url) }
    Then { result_url.eql? property_url }
  end

end
