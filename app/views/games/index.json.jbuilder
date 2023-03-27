json.data do
  json.array! @games do |game|
    json.game do
      json.array! ['games']
      json.array! game.couples do |couple|
        json.partial! 'couple', couple: couple
      end
    end
    json.year_game game.year_game
    if game.worker_without_play
      json.not_play do
        json.worker game.worker_without_play.name
        json.not_play game.year_game
      end
    end
  end
end
