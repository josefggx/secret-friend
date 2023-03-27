class Worker < ApplicationRecord
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/ }, length: { minimum: 3 }
  validates :location_id, presence: true

  belongs_to :location
  has_many :couples_as_first_worker, class_name: 'Couple', foreign_key: 'first_worker_id'
  has_many :couples_as_second_worker, class_name: 'Couple', foreign_key: 'second_worker_id'
  has_many :games_without_play, class_name: 'Game', foreign_key: 'worker_without_play_id'

  def find_restricted_partner_ids(year)
    [year - 2, year - 1, year + 1, year + 2].map { |specific_year| find_partner_for_year(specific_year)&.id }
  end

  private

  def find_partner_for_year(year)
    couple = find_couple_for_year(year)
    return nil unless couple

    couple.first_worker_id == id ? couple.second_worker : couple.first_worker
  end

  def find_couple_for_year(year)
    game = Game.find_by_year_game(year)
    return nil unless game

    Couple.where(game_id: game.id).where('first_worker_id = ? OR second_worker_id = ?', id, id).first
  end
end
