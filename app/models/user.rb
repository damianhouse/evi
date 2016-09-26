class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :appointments
  has_many :patients
  has_many :invoices
  validates_presence_of :first_name, :last_name


  def full_name
    "#{first_name} #{last_name}"
  end

end
