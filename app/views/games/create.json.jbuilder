json.data do
  json.year_game @game.year_game
  json.worker_without_play do
    if @game.worker_without_play.present?
      json.id @game.worker_without_play.id
      json.name @game.worker_without_play.name
      json.location @game.worker_without_play.location.name
    end
  end
  json.all_games do
    json.array! @game.couples do |couple|
      json.game do
        json.partial! 'couple', couple: couple
      end
    end
  end
end
