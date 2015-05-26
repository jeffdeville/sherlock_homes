RSpec.configure do |c|
  c.filter_run_excluding skip_ci: true
end if ENV['TRAVIS']
