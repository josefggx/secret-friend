class Location < ApplicationRecord
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/ },
                   length: { in: 3..30 }, uniqueness: true

  has_many :workers
end
