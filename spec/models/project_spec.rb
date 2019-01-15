require 'rails_helper'
require_relative '../shared/size_group.rb'

RSpec.describe Project do
  it_behaves_like 'sizeable' do
    let(:instance) { Project.new }
  end
  let(:task) { Task.new }
    
  describe 'completion' do
    let(:project) { FactoryBot.build_stubbed(:project) }
    
    it 'considers a project with no tasks to be done' do
      expect(project).to be_done
    end
    
    it 'knows that a project with an incomplete task is not done' do
      project.tasks << task
      expect(project).not_to be_done
    end
    
    it 'marks a project done if its tasks are done' do
      project.tasks << task
      task.mark_as_finished
      expect(project).to be_done
    end
    
    it 'properly handles a blank project' do
      expect(project.velocity).to eq(0)
      expect(project.daily_velocity).to eq(0)
      expect(project.projected_days_remaining).to be_nan
      expect(project).not_to be_on_schedule
    end
  end
  
  describe 'estimates' do
    let(:project_with_a_single_completed_task) { FactoryBot.build(:project, tasks: [newly_finished_task]) }
    let(:project_with_multiple_tasks) { FactoryBot.build(:project, tasks: [newly_finished_task, old_finished_task, small_unfinished_task, large_unfinished_task]) }
    let(:newly_finished_task) { FactoryBot.build_stubbed(:task, size: 3, finished_at: 1.day.ago) }
    let(:old_finished_task) { FactoryBot.build_stubbed(:task, size: 2, finished_at: 6.months.ago) }
    let(:small_unfinished_task) { FactoryBot.build_stubbed(:task, size: 1) }
    let(:large_unfinished_task) { FactoryBot.build_stubbed(:task, size: 4) }
    
    it 'calculates total size of project with one completed task' do
      expect(project_with_a_single_completed_task.total_size).to eq(3)
    end
    
    it 'calculates total size of project with multiple tasks' do
      expect(project_with_multiple_tasks.total_size).to eq(10)
    end  
    
    it 'calculates remaining size of project with one complete task' do
      expect(project_with_a_single_completed_task.remaining_size).to eq(0)
    end
    
    it 'knows its velocity' do
      expect(project_with_multiple_tasks.velocity).to eq(3)
    end
    
    it 'knows its rate' do
      expect(project_with_multiple_tasks.daily_velocity).to eq( 3.0 / 21 ) 
    end
    
    it 'knows its projected days remaining' do
      expect(project_with_multiple_tasks.projected_days_remaining).to eq(35) 
    end
    
    it 'knows if it is not on schedule' do
      project_with_multiple_tasks.due_date = 1.week.from_now
      expect(project_with_multiple_tasks).not_to be_on_schedule
    end
    
    it 'knows if it is on schedule' do
      project_with_multiple_tasks.due_date = 6.months.from_now
      expect(project_with_multiple_tasks).to be_on_schedule
    end
    
    it 'can calculate total size' do
      expect(project_with_multiple_tasks).to be_of_size(10)
      expect(project_with_multiple_tasks).not_to be_of_size(5)
    end
    
    it 'can calculate remaining size' do
      expect(project_with_multiple_tasks).to be_of_size(5).for_unfinished_tasks_only
    end
  end
  
  # describe 'how we use FactoryBot' do
  #   it 'uses factory_bot slug block' do
  #     project = create(:project, name: 'Book To Write')
  #     expect(project.slug).to eq('book-to-write')
  #   end
  # end
  
  describe "with a task" do

      let(:project) { build_stubbed(:project, tasks: [task]) }
      let(:task) { build(:task) }
      let(:worthless_project) { FactoryBot.build_stubbed(:project) }
      let(:worthless_project_task) { FactoryBot.build_stubbed(:task) }
      let(:worthless_project_with_multiple_tasks) { FactoryBot.build_stubbed(:project_with_multiple_tasks) }
      let(:meaningless_project_with_task_pair) { FactoryBot.build_stubbed(:project_with_task_pair)}
      it 'considers a project with an incomplete task as not done' do
        expect(project).not_to be_done
      end
  
      it 'marks a project done if its tasks are done' do
        task.mark_as_finished
        expect(project).to be_done
      end
      
      it 'worthless, meaningless tests' do
        expect(worthless_project_with_multiple_tasks.total_size).to eq(100)
        expect(meaningless_project_with_task_pair.total_size).to eq(2)
        actual_titles = meaningless_project_with_task_pair.tasks.map(&:title)
        expected_titles = ['ToDo List', 'ToDo List']
        expect(actual_titles).to eq(expected_titles)
      end
    end
end