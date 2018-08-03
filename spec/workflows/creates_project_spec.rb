require 'rails_helper'

RSpec.describe CreatesProject do
  
  let(:creator) { CreatesProject.new(
    name:"Project Runway", task_string: task_string)}
    
  describe "initialization" do
    let(:task_string) { "" }
    it "creates a project given a name" do
      creator.build
      expect(creator.project.name).to eq("Project Runway")
    end
  end
  
  describe "task string parsing" do
    let(:tasks) { creator.parse_string_as_tasks }
    
    describe 'with an empty string' do
     let(:task_string) { "" }
     specify { expect(tasks).to be_empty }
    end
    
    it "parses an empty string" do
      creator = CreatesProject.new(name: "Project Runway", task_string: "")
      tasks = creator.parse_string_as_tasks
      expect(tasks).to be_empty
    end
    
    describe 'with a single string' do 
      let(:task_string) { "Start Things" }
      it { expect(tasks.size).to eq(1) }
      it { expect(tasks.first).to have_attributes(
        title: "Start Things", size: 1) }
    end
    
    
    it "parses a single string" do 
      creator = CreatesProject.new(name: "Project Runway", task_string: "Start Things")
      tasks = creator.parse_string_as_tasks  
      expect(tasks.size).to eq(1)
      expect(tasks.first).to have_attributes(title:  "Start Things", size: 1)
    end
    
    describe "with a single string of some size " do
      let(:task_string) { "Start Things:3" }
      it { expect(tasks.size).to eq(1) }
      it { expect(tasks.first).to have_attributes(
        title: "Start Things", size: 3) }
    end
    
    
    it "parses a single string with size" do 
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:3")
      tasks = creator.parse_string_as_tasks  
      expect(tasks.size).to eq(1)
      expect(tasks.first).to have_attributes(title:  "Start Things", size: 3)
    end
    
    describe "handles a single string with size zero" do
      let(:task_string) { "Start Things:0" }
      it { expect(tasks.size).to eq(1) }
      it { expect(tasks.first).to have_attributes(
        title: "Start Things", size: 1) }
    end
    
    it "parses a single string with size zero" do
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:0")
      tasks = creator.parse_string_as_tasks
      expect(tasks.size).to eq(1)
      expect(tasks.first).to have_attributes(title: "Start Things", size: 1)
    end
    
    describe "handles a single string with malformed size" do
      let(:task_string) { "Start Things:" }
      it { expect(tasks.size).to eq(1) }
      it { expect(tasks.first).to have_attributes(
        title: "Start Things", size: 1) }
    end
    
    it "parses a single string with malformed size" do
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:")
      tasks = creator.parse_string_as_tasks
      expect(tasks.size).to eq(1)
      expect(tasks.first).to have_attributes(title: "Start Things", size: 1)
    end
    
    describe 'parses a single string with negative size' do 
      let(:task_string) { "Start something:-1" }
      
      describe "subject size" do
         subject { tasks.size }
         it { is_expected.to eq(1) }
         # tasks.size.is_expected.to eq(1)
       end
      
      describe 'fun with subjects' do
        subject { tasks.first }
        it { is_expected.to have_attributes(title: "Start something", size: 1) }
      end
    end
    
    it "parses a single string with negative size" do
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:-1")
      tasks = creator.parse_string_as_tasks
      expect(tasks.size).to eq(1)
      expect(tasks.first).to have_attributes(title: "Start Things", size: 1)
    end
    
    describe 'parses a single string with non-numeric size' do 
      let(:task_string) { "Start Things:aardvark" }
      it { expect(tasks.size).to eq(1) }
      it { expect(tasks.first).to have_attributes(title: "Start Things", size:1) }
    end
    
    it "parses a single string with non-numeric size" do
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:aardvark")
      tasks = creator.parse_string_as_tasks
      expect(tasks.size).to eq(1)
      expect(tasks.first).to have_attributes(title: "Start Things", size: 1)
    end
    
    describe "with multiple tasks" do
      let(:task_string) { "Start Things:1\nContinue Things:2\nFinish Things:3" }
      it { expect(tasks.size).to eq(3) }
      
      it 'TRY THIS' do
        expect(tasks).to match([have_attributes(title: 'Start Things', size: 1),
                                have_attributes(title: 'Continue Things', size: 2),
                                have_attributes(title: 'Finish Things', size: 3)])
      end
    end

    
    it "parses multiple tasks" do
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:3\nEnd Things:2")
      tasks = creator.parse_string_as_tasks
      expect(tasks.size).to eq(2)
      expect(tasks).to match([
         an_object_having_attributes(title: "Start Things", size: 3),
         an_object_having_attributes(title: "End Things", size: 2)])
    end
    
    describe "attaches tasks to the project" do
      let(:task_string) { "Start Things:3\nEnd Things:2" }
      before(:example) { creator.create }
      it { expect(creator.project.tasks.size).to eq(2) }
      it { expect(creator.project).not_to be_a_new_record }
    end
    
    it 'attaches tasks to the project' do  
      creator = CreatesProject.new(name: "Project Runway", 
                                   task_string: "Start Things:3\nEnd Things:2")
      creator.create 
      expect(creator.project.tasks.size).to eq(2)
      expect(creator.project).not_to be_a_new_record
    end
  end
  
  describe "failure cases" do
    it "fails when trying to save a project with no name" do
      creator = CreatesProject.new(name: "", task_string: "")
      creator.create
      expect(creator).not_to be_a_success
    end
  end
end