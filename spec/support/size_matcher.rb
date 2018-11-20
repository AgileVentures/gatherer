RSpec::Matchers.define :be_of_size do |expected|
  match do |actual|
   actual.size == expected
  end
end