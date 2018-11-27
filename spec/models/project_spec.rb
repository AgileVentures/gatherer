require "rails_helper"
require_relative '../shared/size_group.rb'

RSpec.describe Project do
  it_behaves_like "sizeable" do
    let(:instance) { Project.new }
  end
    
  describe "completion" do
    let(:project) { Project.new }
    let(:task) { Task.new }
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
    
    it "properly handles a blank project" do
      expect(project.velocity).to eq(0)
      expect(project.daily_velocity).to eq(0)
      expect(project.projected_days_remaining).to be_nan
      expect(project).not_to be_on_schedule
    end
  end
  
  describe 'estimates' do
    let(:project_with_a_single_completed_task) { Project.new }
    let(:project_with_multiple_tasks) { Project.new }
    let(:newly_done) { Task.new(size: 3, finished_at: 1.day.ago) }
    let(:old_done) { Task.new(size: 2, finished_at: 6.months.ago) }
    let(:small_not_done) { Task.new(size: 1) }
    let(:large_not_done) { Task.new(size: 4) }
    
    before(:example) do
      project_with_a_single_completed_task.tasks = [newly_done]
      project_with_multiple_tasks.tasks = [newly_done, old_done, small_not_done, large_not_done]
    end
    
    it 'calculates total size of project with one completed task' do
      expect(project_with_a_single_completed_task.total_size).to eq(3)
    end
    
    it 'calculates total size of project with multiple tasks' do
      expect(project_with_multiple_tasks.total_size).to eq(10)
    end  
    
    it 'calculates remaining size of project with one complete task' do
      expect(project_with_a_single_completed_task.remaining_size).to eq(0)
    end
    
    it "knows its velocity" do
      expect(project_with_multiple_tasks.velocity).to eq(3)
    end
    
    it "knows its rate" do
      expect(project_with_multiple_tasks.daily_velocity).to eq( 3.0 / 21 ) 
    end
    
    it "knows its projected days remaining" do
      expect(project_with_multiple_tasks.projected_days_remaining).to eq(35) 
    end
    
    it "knows if it is not on schedule" do
      project_with_multiple_tasks.due_date = 1.week.from_now
      expect(project_with_multiple_tasks).not_to be_on_schedule
    end
    
    it "knows if it is on schedule" do
      project_with_multiple_tasks.due_date = 6.months.from_now
      expect(project_with_multiple_tasks).to be_on_schedule
    end
    
    it 'can calculate total size' do
      expect(project_with_multiple_tasks).to be_of_size(10)
      expect(project_with_multiple_tasks).not_to be_of_size(5)
    end
    
    it "can calculate remaining size" do
      expect(project_with_multiple_tasks).to be_of_size(5).for_unfinished_tasks_only
    end
  end
    
end