RSpec.configure do |config|
  config.before(:example, type: :system) do
    driven_by :rack_test
  end
end
require 'capybara-screenshot/rspec'