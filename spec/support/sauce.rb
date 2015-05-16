# Use Capybara integration
require "sauce"
require "sauce/capybara"

# Set up configuration
Sauce.config do |c|
  c[:browsers] = [
    ["OS X 10.9", "Firefox", "35"]
  ]
  c[:start_tunnel] = false
end
