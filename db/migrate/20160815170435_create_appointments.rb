class CreateAppointments < ActiveRecord::Migration[5.0]
  def change
    create_table :appointments do |t|
      t.integer :patient_id
      t.integer :user_id
      t.string :note
      t.string :clinic
      t.datetime :start_time
      t.datetime :end_time
      t.float :miles_driven
      t.boolean :complete
      t.boolean :paid_for

      t.timestamps
    end
  end
end
