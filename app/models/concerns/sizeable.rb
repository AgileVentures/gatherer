module Sizeable
  extend ActiveSupport::Concern

  def small?
    size <= 1
  end

  def epic?
    size >= 10
  end
end