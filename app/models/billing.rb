class Billing < ApplicationRecord
  has_many :charges, dependent: :destroy
  belongs_to :contract

  validates :contract_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :billing_reference_date, :rent_reference_date, presence: true

  validate :contract_must_be_active
  # TODO: validate :unique_billing_by_month

  enum :status, [ :waiting_payment, :paid ]

  accepts_nested_attributes_for :charges

  def calculate_total_amount
    self.amount = charges.sum(:amount)
  end

  def billing_reference_end_date
    billing_reference_date + 1.month
  end

  def rent_reference_end_date
    rent_reference_date + 1.month
  end

  def billing_reference_period
    "#{billing_reference_date.strftime("%d/%m/%y")} - #{billing_reference_end_date.strftime("%d/%m/%y")}"
  end

  def rent_reference_period
    "#{rent_reference_date.strftime("%d/%m/%y")} - #{rent_reference_end_date.strftime("%d/%m/%Y")}"
  end

  def contract_must_be_active
    return if contract&.active?

    errors.add(:contract, "Não há contratos ativos. Deverá ter ao menos um contrato ativo para criar uma cobrança.")
  end
end
