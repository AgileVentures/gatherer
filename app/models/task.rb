class Task < ApplicationRecord
  belongs_to :project
 # attr_reader :size
 # attr_accessor :finished_at
  
  #def initialize(task_properties = {})
   # @size        = task_properties[:size]
    #self.finished_at= task_properties[:finished_at]
    # mark_as_finished(task_properties[:finished_at]) if task_properties[:finished_at]
 # end   
  
  def mark_as_finished(date = Time.current)
    self.finished_at = date
  end

  def finished?
    finished_at.present?
  end    
  
  def unfinished?
    !finished?
  end  
  
  def part_of_velocity?
    finished_at&.between?(Project.velocity_window_in_days.days.ago, Time.now) || false
  end  
  
  def points_toward_velocity
    part_of_velocity? ? size : 0
  end  
end