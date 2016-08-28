class AddCancelledToAppointment < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :cancelled, :boolean, default: false
  end
end
