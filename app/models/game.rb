class Game < ApplicationRecord
  attr_accessor :available_workers, :couples

  def initialize(attributes = nil)
    super
    @couples = []
  end

  # has_many :worker_without_play, foreign_key: :id, class_name: 'Worker'
  # has_one :worker_without_play, class_name: 'Worker', foreign_key: :id
  # belongs_to :worker, class_name:"Worker", foreign_key: :id

  # validates :workers, :length => { :minimum => 2 }

  validates :year_game, numericality: { in: 2023..2032 }, uniqueness: true

  validate :has_at_least_two_workers

  def worker_without_play
    Worker.find(self.worker_without_play_id) if self.worker_without_play_id
    # worker = Worker.find(self.worker_without_play_id)
    # OpenStruct.new(id: worker.id, name: worker.name, location: worker.location.name)
  end

  def has_at_least_two_workers
    if available_workers.size < 2
      errors.add(:available_workers, "Deben haber al menos 2 empleados para jugar.")
    end
  end
end
