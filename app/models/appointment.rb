class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :patient
  validates_presence_of :start_time, :end_time, :clinic, :patient_id
  validate :end_time_is_after_start_time

  private

  def end_time_is_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "Cannot be before the start time")
    end
  end
end
