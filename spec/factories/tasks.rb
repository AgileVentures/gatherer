FactoryBot.define do 
  factory :task do
    project
    title { "Thing to do-#{Time.now}" }
    size  1
    finished_at nil
  end
end