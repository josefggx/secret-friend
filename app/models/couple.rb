class Couple < ApplicationRecord
  validates :first_worker, presence: true
  validates :second_worker, presence: true
  validates :game, presence: true

  belongs_to :first_worker, class_name: 'Worker', foreign_key: 'first_worker_id'
  belongs_to :second_worker, class_name: 'Worker', foreign_key: 'second_worker_id'
  belongs_to :game
end
