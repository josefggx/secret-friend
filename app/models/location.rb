class Location < ApplicationRecord
  has_many :workers

  validates :name, presence: true, length: { minimum: 3 },
            uniqueness: true, format: { with: /\A[a-zA-Z0-9\s]+\z/ }
end
