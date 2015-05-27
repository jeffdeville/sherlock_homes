require 'spec_helper'

RSpec.describe SherlockHomes::Google, skip_ci: true do

  Given(:query) { 'algonauti' }
  When(:result) { subject.class.search(query) }
  Then { result.eql? 'http://www.algonauti.com/' }

end
