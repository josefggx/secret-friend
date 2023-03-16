json.data do
  json.year_game @game.year_game
  json.worker_without_play @game.worker_without_play
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
