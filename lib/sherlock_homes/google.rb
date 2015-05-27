module SherlockHomes

  class Google < SitePrism::Page
    set_url 'https://www.google.com'

    element :search_field,  "input[name='q']"
    element :search_button, "input[name='btnK']"

    element :result, '#rso > div.srg > li:nth-child(1) > div > h3 > a'


    def self.search(query)
      puts "query: #{query}"
      Scraper.restart_phantomjs
      google = new
      google.load
      google.search_field.set query
      google.search_button.click
      google.wait_for_result
      href = google.result['href']
      puts "href: #{href}"
      href
    rescue Capybara::ElementNotFound
      nil
    end

  end

end
