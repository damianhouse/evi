class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.integer :patient_id
      t.integer :user_id
      t.string :note
      t.string :clinic
      t.datetime :start_time
      t.datetime :end_time
      t.float :miles_driven, default: 0.0
      t.boolean :complete, default: false
      t.boolean :paid_for, default: false

      t.timestamps
    end
  end
end
