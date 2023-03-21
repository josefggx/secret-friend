class Game < ApplicationRecord
  belongs_to :worker_without_play, class_name: 'Worker', optional: true
  has_many :couples, dependent: :destroy

  validates :year_game, numericality: { in: 2023..2032 }, uniqueness: true
  validate :has_at_least_two_workers
  validate :has_at_least_one_couple

  def has_at_least_two_workers
    errors.add(:available_workers, 'Deben haber al menos 2 empleados para jugar.') if Worker.count < 2
  end

  def has_at_least_one_couple
    errors.add(:couples, 'Debe haber al menos una pareja para jugar.') if couples.empty?
  end
end