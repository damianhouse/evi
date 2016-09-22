json.extract! invoice, :id, :user_id, :miles_total, :hours_total, :total_paid, :paid_on, :start_date, :end_date, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)