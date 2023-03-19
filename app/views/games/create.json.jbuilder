json.data do
  json.year_game @game.year_game
  # json.worker_without_play @game.worker_without_play.marshal_dump if @game.worker_without_play.present?
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
        json.set! "couple_#{couple.id}" do
          json.first_player_name couple.first_worker.name
          json.first_player_id couple.first_worker.id
          json.second_player_name couple.second_worker.name
          json.second_player_id couple.second_worker.id
        end
      end
    end
  end
end
