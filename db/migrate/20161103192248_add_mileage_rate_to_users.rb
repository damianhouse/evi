class AddMileageRateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mileage_rate, :float, default: 0.16
  end
end
