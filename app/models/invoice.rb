class Invoice < ApplicationRecord
  belongs_to :user
  def to_hours
    self / (60*60)
  end
end
