class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :buildings, foreign_key: "landlord_id"
  has_many :tenants, class_name: "User", foreign_key: "landlord_id", dependent: :destroy
  has_many :contracts, dependent: :destroy
  belongs_to :landlord, class_name: "User", optional: true

  enum :role, [ :landlord, :tenant ]

  scope :tenants_of, ->(landlord) { where(landlord_id: landlord.id) }

  def add_tenant
    return unless landlord?

    tenants.create(tenant_params)
  end

  def tenant_list
    return unless landlord?

    tenants
  end
end
