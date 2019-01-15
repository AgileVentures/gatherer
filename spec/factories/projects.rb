FactoryBot.define do 
  factory :project do
    name 'Project Runway'
    due_date 1.week.from_now
    # slug { "#{name.downcase.gsub('', '-')}" }
    
    factory :project_with_multiple_tasks do
      tasks { build_stubbed_list(:task, 100) }
    end
    factory :project_with_task_pair do
      tasks { build_pair(:task, title: "ToDo List") }
    end
  end
end