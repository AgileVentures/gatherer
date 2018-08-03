class Project < ApplicationRecord
    has_many :tasks, dependent: :destroy
    validates_presence_of :name
    
    def self.velocity_window_in_days
      21
    end
    
    def unfinished_tasks
      tasks.select(&:unfinished?)
    end
    
    def done?
      unfinished_tasks.empty?
    end

    def remaining_size
      unfinished_tasks.sum(&:size)
    end
    
    def total_size
      tasks.sum(&:size)
    end
    
    def finished_velocity
      tasks.sum(&:points_toward_velocity)
    end
    
    def current_rate
      finished_velocity * 1.0 / Project.velocity_window_in_days
    end
    
    def projected_days_remaining
      remaining_size / current_rate
    end
    
    def on_schedule?
      return false if projected_days_remaining.nan?
      (Time.zone.today + projected_days_remaining) <= due_date
    end
end

