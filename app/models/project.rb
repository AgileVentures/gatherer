class Project < ApplicationRecord
  include Sizeable
  has_many :tasks, dependent: :destroy
  validates_presence_of :name
  
  def self.velocity_window_in_days
    21
  end
  
  def unfinished_tasks
    tasks.select(&:unfinished?)
  end
  
  def done?
    unfinished_tasks.none?
  end

  def remaining_size
    unfinished_tasks.sum(&:size)
  end
  
  def total_size
    tasks.sum(&:size)
  end
  
  alias_method :size, :total_size
  
  def velocity
    tasks.sum(&:points_toward_velocity)
  end
  
  def daily_velocity
    velocity * 1.0 / Project.velocity_window_in_days
  end
  
  def projected_days_remaining
    remaining_size / daily_velocity
  end
  
  def on_schedule?
    return false if projected_days_remaining.nan?
    (Time.zone.today + projected_days_remaining) <= due_date
  end
end

