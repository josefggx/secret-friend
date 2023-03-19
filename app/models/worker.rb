class Worker < ApplicationRecord
  belongs_to :location

  has_many :games_without_play, class_name: 'Game', foreign_key: 'worker_without_play_id'

  has_many :couples_as_first_worker, class_name: "Couple", foreign_key: "first_worker_id"
  has_many :couples_as_second_worker, class_name: "Couple", foreign_key: "second_worker_id"

  validates :location_id, :presence => true
  validates :name, presence: true, length: { minimum: 3 },
            format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "only allows letters and numbers"  }

  def partner_for_year(year)
    couple = couple_for_year(year)
    return nil unless couple

    if couple.first_worker_id == id
      couple.second_worker
    else
      couple.first_worker
    end
  end

  private

  def couple_for_year(year)
    game = Game.find_by_year_game(year)
    return nil unless game

    Couple.where(game_id: game.id)
          .where("first_worker_id = ? OR second_worker_id = ?", id, id)
          .first
  end
end
