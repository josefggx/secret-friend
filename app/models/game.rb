class Game < ApplicationRecord
  attr_accessor :available_workers, :couples

  def initialize(attributes = nil)
    super
    @couples = []
  end


  # has_one :not_playing_worker, through: :not_playing_worker, dependent: :destroy, class_name: 'NotPlayingWorker', foreign_key: :worker_id
  has_one :not_playing_worker, dependent: :destroy, class_name: 'NotPlayingWorker'

  validates :year_game, numericality: { in: 2023..2032 }, uniqueness: true

  validate :has_at_least_two_workers

  # def worker_without_play
  #   Worker.find(self.worker_without_play_id) if self.worker_without_play_id
  #   # worker = Worker.find(self.worker_without_play_id)
  #   # OpenStruct.new(id: worker.id, name: worker.name, location: worker.location.name)
  # end

  def has_at_least_two_workers
    if available_workers.size < 2
      errors.add(:available_workers, "Deben haber al menos 2 empleados para jugar.")
    end
  end
end
