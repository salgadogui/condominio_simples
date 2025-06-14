json.extract! billing, :id, :contract_id, :billing_reference_date, :rent_reference_date, :amount, :created_at, :updated_at
json.url billing_url(billing, format: :json)
