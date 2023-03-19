class Couple < ApplicationRecord
  belongs_to :first_worker, class_name: 'Worker', foreign_key: 'first_worker_id'
  belongs_to :second_worker, class_name: 'Worker', foreign_key: 'second_worker_id'
  belongs_to :game

  validates :first_worker, presence: true
  validates :second_worker, presence: true
  validates :game, presence: true
  validate :different_workers

  #TODO: Revisar si esta línea de abajo nos es útil
  delegate :year_game, to: :game, prefix: true

  def different_workers
    if first_worker_id == second_worker_id
      errors.add(:second_worker_id, "must be different from first worker")
    end
  end
end

