require 'rails_helper'

RSpec.describe Task do
  let(:unsized_task) { Task.new }
  describe 'initialization' do
    it 'is unfinished by default' do
      expect(unsized_task).to be_unfinished
    end
  end 
  
  describe 'in progress' do
    it 'can be marked finished' do
      unsized_task.mark_as_finished
      expect(unsized_task).to be_finished
    end
  end
  
  describe 'velocity' do
    let(:basic_task) { Task.new(size: 3) }

    it 'does not count an unfinished task toward velocity' do
      expect(basic_task).not_to be_a_part_of_velocity
      expect(basic_task.points_toward_velocity).to eq(0)
    end

    it 'counts a recently finished task toward velocity' do
      basic_task.mark_as_finished(1.day.ago) 
      expect(basic_task).to be_a_part_of_velocity
      expect(basic_task.points_toward_velocity).to eq(3)
    end

    it 'does not count tasks finished outside the velocity window toward velocity'  do
      basic_task.mark_as_finished(22.days.ago) 
      expect(basic_task).not_to be_a_part_of_velocity
      expect(basic_task.points_toward_velocity).to eq(0)
    end
  end
  
  describe 'finders functionality' do
    let (:creative_project) { Project.create(name: 'Really creative name') }
    
    before do
      @small_and_finished_long_ago      = creative_project.tasks.create(finished_at: 1.year.ago, title: 'Small', size: 1)
      @medium_and_finished_sometime_ago = creative_project.tasks.create(finished_at: 3.months.ago, title: 'Medium', size: 3)
      @large_and_recently_finished_task = creative_project.tasks.create(finished_at: 1.day.ago, title: 'Large', size: 100)
    end
    
    #large 
    it 'returns tasks larger than 3' do
      large_tasks_only = Task.large
      expect(large_tasks_only.size).to eq(1)
    end
   
    # most recent
    it 'finds the most recently finished tasks' do
      most_recent_tasks_array = Task.most_recently_finished.pluck(:title)
      ordered_titles = [@large_and_recently_finished_task.title, 
                        @medium_and_finished_sometime_ago.title, 
                        @small_and_finished_long_ago.title
                       ]
      expect(most_recent_tasks_array).to eq(ordered_titles)
    end
    
    # alphabetized title
    it 'alphabetized title' do
      alphabetized_title = Task.alphabetize_title.pluck(:title)
      ordered_titles = [@large_and_recently_finished_task.title, 
                        @medium_and_finished_sometime_ago.title, 
                        @small_and_finished_long_ago.title
                       ]
      expect(alphabetized_title).to eq(ordered_titles)
    end
    
    it 'finds large and most recent tasks' do
      unfinished_task = creative_project.tasks.create(finished_at: nil, title: 'Unfinished', size: 5)
      # expect(Task.large_and_recently_finished.map(&:title)).to eq(['Large'])
      # alternate version vvvv
      expect(Task.large_and_recently_finished).to match([an_object_having_attributes(title: "Large")])
    end
  end
end
