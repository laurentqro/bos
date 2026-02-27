class ClientNationality < ApplicationRecord
  belongs_to :client

  validates :country_code, presence: true, length: {is: 2}
  validates :country_code, uniqueness: {scope: :client_id}
end
