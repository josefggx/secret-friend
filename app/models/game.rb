class Game < ApplicationRecord
  validates :year_game, presence: true, numericality: { in: 2023..2032 }, uniqueness: true
  validate :has_at_least_two_workers
  validate :has_at_least_one_couple

  belongs_to :worker_without_play, class_name: 'Worker', optional: true
  has_many :couples, dependent: :destroy

  def has_at_least_two_workers
    errors.add(:workers, :workers_required) if Worker.count < 2
  end

  def has_at_least_one_couple
    errors.add(:couples, :couples_required) if couples.empty?
  end
end
