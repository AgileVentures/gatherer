class CreatesProject
  attr_accessor :name, :project, :task_string
  
  def initialize(name: "Leandro", task_string: "")
    @name = name
    @task_string = task_string
    @success = false
  end
  
  def success?
    @success
  end
 
  def build
    self.project = Project.new(name: name)
    project.tasks = parse_string_as_tasks
    #p project
    project
  end
  
  def create
    build
    # require 'pry'; binding.pry
    project.save
  end
  
  def parse_string_as_tasks
    task_string.split("\n").map do |one_task|
      title, size_string = one_task.split(":")
      Task.new(title: title, size: size_as_integer(size_string))
    end
  end  
  
  def size_as_integer(size_string)
    return 1 if size_string.blank? || size_string.to_i < 1
    size_string.to_i
  end
end