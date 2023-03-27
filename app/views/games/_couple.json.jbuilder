json.set! "couple_#{couple.id}" do
  json.first_player_name couple.first_worker.name
  json.first_player_id couple.first_worker.id
  json.second_player_name couple.second_worker.name
  json.second_player_id couple.second_worker.id
end
