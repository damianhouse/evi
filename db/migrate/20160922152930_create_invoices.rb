class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.float :miles_total
      t.float :hours_total
      t.float :total_paid
      t.date :paid_on
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
