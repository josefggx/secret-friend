class Game < ApplicationRecord
  # attr_accessor :couples
  belongs_to :worker_without_play, class_name: 'Worker', optional: true
  has_many :couples, dependent: :destroy

  # def initialize(attributes = nil)
  #   super
  #   @couples = []
  # end

  def has_at_least_two_workers
    errors.add(:available_workers, "Deben haber al menos 2 empleados para jugar.") if Worker.count < 2
  end
end
