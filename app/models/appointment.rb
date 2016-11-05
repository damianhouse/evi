class Appointment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :patient
  validates_presence_of :start_time, :clinic, :patient_id
  validate :end_time_is_after_start_time
  validate :only_one_status

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def end_time_is_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "Cannot be before the start time")
    end
  end

  def only_one_status
    if complete == true && (cancelled == true || no_show == true)
      errors.add(:complete, "There can be only one status")
    elsif cancelled == true && (complete == true || no_show == true)
      errors.add(:cancelled, "There can be only one status")
    elsif no_show == true && (cancelled == true || complete == true)
      errors.add(:no_show, "There can be only one status")
    end
  end
end
