require 'spec_helper'

RSpec.describe SherlockHomes::Scraper::Redfin, sauce: true do

  Given(:scraper) do
    subject.base_url 'https://www.redfin.com/PA/Allentown/2354-S-Cedar-Crest-Blvd-18103/home/59034427'
    subject
  end

  When(:result) { scraper.crawl }

  Then { expect(result.page_title).to eql('2354 S Cedar Crest Blvd, Lower Macungie Twp, PA 18103 | MLS# 486144 | Redfin') }
  And { expect(result.walk_score.to_i).to eql(2) }

end
