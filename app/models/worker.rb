class Worker < ApplicationRecord
  belongs_to :location
  # has_many :games_without_play, class_name: 'Game', foreign_key: :id

  # has_many :games_as_first_player, :foreign_key => 'first_player_id', :class_name => 'WorkerGame'
  # has_many :games_as_second_player, :foreign_key => 'second_player_id', :class_name => 'WorkerGame'

  # def couples
  #   games_as_first_player + games_as_second_player
  # end

  validates :location_id, :presence => true

  validates :name, presence: true, length: { minimum: 3 },
            format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "only allows letters and numbers"  }

end
