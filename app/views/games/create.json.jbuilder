json.data do
  json.year_game @game.year_game
  # json.worker_without_play @game.worker_without_play.marshal_dump if @game.worker_without_play.present?
  json.worker_without_play do
    if @game.not_playing_worker.present?
      json.id @game.not_playing_worker.worker.id
      json.name @game.not_playing_worker.worker.name
      json.location @game.not_playing_worker.worker.location.name
    end
  end
  json.all_games do
    json.array! @game.couples do |couple|
      json.game couple
    end
  end

  # json.worker_without_play @game.worker_without_play
  # json.all_games
  # json.location do
  #   json.id @location.id
  #   json.title @location.name
  # end
end
