class Patient < ApplicationRecord
  has_many :users
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_format_of :email, with: /@/  
  validates :phone_number, presence: true

end
