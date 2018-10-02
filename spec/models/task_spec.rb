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
  
  describe "finders functionality" do
    it 'finds large and most recent tasks' do
      large_and_recently_done_variable = Task.create(title: "Done", size: 100)
      large_and_recently_done_variable.mark_as_finished(2.days.ago) 
      Task.create(finished_at: nil, title: "Not done", size: 3)
      expect(Task.large_and_recently_done.pluck(:title)).to eq(["Done"])
    end
  end
end