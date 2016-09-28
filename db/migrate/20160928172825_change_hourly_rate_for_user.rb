class ChangeHourlyRateForUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :hourly_rate, :float, default: 0.0
  end
end
