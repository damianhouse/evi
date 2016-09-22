class AddHourlyRateToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hourly_rate, :float
  end
end
