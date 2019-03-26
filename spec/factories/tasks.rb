FactoryBot.define do 
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    # title { "Thing to do-#{Time.now}" }
    size  3
    project
    finished_at nil 
    
    trait :small do
      size 1
    end

    trait :large do
      size 5
    end

    trait :urgent do
      due_date { 1.day.from_now }
    end

    trait :nonurgent do
      due_date { 1.month.from_now }
    end

    trait :newly_finished do
      finished_at { 1.day.ago }
    end

    trait :old_finished do
      finished_at { 6.months.ago }
    end

    factory :trivial do
      small 
      nonurgent
    end
    
    factory :serious do
      large 
      urgent
    end
  end
end