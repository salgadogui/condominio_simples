json.extract! charge, :id, :billing_id, :description, :amount, :type, :created_at, :updated_at
json.url charge_url(charge, format: :json)
