class NotPlayingWorker < ApplicationRecord
  belongs_to :game
  belongs_to :worker
end