# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
counter = 5

while counter >= 0
  i = User.create!(email: "#{counter}" + "@gmail.com", password: "password", first_name: "first" + "#{counter}", last_name: "last" + "#{counter}", hourly_rate: 10.00)
  patient = Patient.create!(email: "#{counter}" + "@gmail.com", first_name: "first" + "#{counter}", last_name: "last" + "#{counter}", phone_number: "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}" + "#{counter}")
  Appointment.create!(user_id: i.id, patient_id: patient.id, clinic: "clinic#{counter}", start_time: (DateTime.now + counter.days), end_time: (DateTime.now + counter.days + counter.minute))
  counter -= 1
end
