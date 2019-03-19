RSpec::Matchers.define :be_of_size do |expected|
  match do |actual|
    @size_to_check = @unfinished ? actual.remaining_size : actual.size
    @size_to_check == expected
  end
  
  description do
    "have tasks totaling #{expected} points"
  end
  
  failure_message do |actual|
    "expected task #{actual.name} to have size #{expected}, was #{@size_to_check}"
  end
  
  failure_message_when_negated do |actual|
    "expected task #{actual.name} not to have size #{expected} but it did👎🏽"
  end
  
  chain :for_unfinished_tasks_only do
    @unfinished = true
  end
end 