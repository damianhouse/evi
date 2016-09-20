class AddNoShowToAppointments < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :no_show, :boolean, default: false
  end
end
