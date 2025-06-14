class Building < ApplicationRecord
  belongs_to :landlord, class_name: "User"
  has_many :blocks, dependent: :destroy
  has_many :apartments, through: :blocks

  validates :name, :address_street, :address_number,
            :address_district, :address_city, :cep, :address_state,
            presence: true
end
