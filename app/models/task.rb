class Task < ApplicationRecord
  belongs_to :project
  
  def ==(other_task)
    raise ArgumentError.new("#{inspect} can only be compared to other tasks") unless other_task.is_a?(Task)
    project_id  == other_task.project_id  &&
    title       == other_task.title       &&
    size        == other_task.size        &&
    finished_at == other_task.finished_at 
  end  
  
  
  def mark_as_finished(date = Time.current)
    self.update(finished_at: date)
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
  
  def self.alphabetize_title
    order("title")
  end
  
  def self.large
    where("size > 3")
  end
  
  def self.most_recent
    order("finished_at DESC")
  end
  
  def self.recent_large_and_alphabetized
    large.most_recent.alphabetize_title
  end
  
  # I'M IN UR CODE #oh no!
  # scope :alphabetize_title, -> { order("title") }
  
end