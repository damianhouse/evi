class Invoice < ApplicationRecord

  def to_hours
    self / (60*60)
  end
end
