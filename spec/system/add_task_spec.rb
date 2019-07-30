require 'rails_helper'

Rspec.describe 'adding a new task' do 
  let!(:project) { create(:project, name: 'Project Bluebook') }
  let!(:task_1) { create( :task, project, title: 'Search Sky', size: 1) }
  let!(:task_2) { create(:task, project, title: 'Use telescope', size: 1)}

  it 'can insert add and order a task' do
    visit(project_path(project))
    fill_in('Task', with: 'Find UFOs')
    select('2', from: 'Size')
    click_on('Add task')
    expect(current_path).to eq(project_path(project))

    within ('#task_3') do
      expect(page).to have_selector('.name', text:'Find UFOs')
      expect(page).to have_selector('.size', text: '2')
      expect(page).not_to have_selector('a', text: 'Text down')
      click_on('Up')
    end

    expect(current_path).to eq(project_path(project))
    within('#task_2') do
      expect(page).to have_selector('.name', text: 'Find UFOs')
    end
  end
end