class AddInvoiceIdToAppointments < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :invoice_id, :integer
  end
end
