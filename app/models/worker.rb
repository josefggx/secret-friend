class Worker < ApplicationRecord
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/ }, length: { in: 3..30 }
  validates :location_id, presence: true

  belongs_to :location
  has_many :couples_as_first_worker, class_name: 'Couple', foreign_key: 'first_worker_id'
  has_many :couples_as_second_worker, class_name: 'Couple', foreign_key: 'second_worker_id'
  has_many :games_without_play, class_name: 'Game', foreign_key: 'worker_without_play_id'
  has_many :games
  has_many :couples,
           ->(worker) { unscope(:where).where('first_worker_id = :id OR second_worker_id = :id', id: worker.id) },
           through: :games

  def self.order_by_without_play_first(workers_without_play_ids)
    order(Arel.sql("ARRAY_POSITION(ARRAY#{workers_without_play_ids}, id),
    CASE WHEN id IN (#{workers_without_play_ids.join(',')}) THEN 0 ELSE random() END"))
  end

  def find_restricted_partners_ids(year)
    [year - 2, year - 1, year + 1, year + 2].map { |specific_year| find_partner_for_year(specific_year)&.id }
  end

  def find_partner_for_year(year)
    couple = couples.where(games: { year_game: year }).first
    couple && (couple.second_worker_id == id ? couple.first_worker : couple.second_worker)
  end
end
