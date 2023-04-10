# frozen_string_literal: true

module GameAsserts
  def game_response_asserts
    game = Game.find_by_year_game(response_data['year_game'])
    assert_equal create_game_valid_keys, response_data.keys, 'Create game response'
    assert_equal game.year_game, response_data['year_game']
    assert_equal game.couples.size, response_data['all_games'].size
    all_games_asserts
    worker_without_play_asserts(game) if response_data['worker_without_play']
  end

  def all_games_asserts
    response_data['all_games'].each do |game_hash|
      couple_key = game_hash['game'].keys.first
      couple_id = couple_key.split('_').last.to_i
      couple = Couple.find(couple_id)
      couple_data = game_hash['game'][couple_key]
      assert_equal couple.first_worker_id, couple_data['first_player_id']
      assert_equal couple.first_worker.name, couple_data['first_player_name']
      assert_equal couple.second_worker_id, couple_data['second_player_id']
      assert_equal couple.second_worker.name, couple_data['second_player_name']
    end
  end

  def worker_without_play_asserts(game)
    worker_without_play = response_data['worker_without_play']
    assert_equal %w[id name location], worker_without_play.keys, 'Create game response'
    assert_equal game.worker_without_play.id, worker_without_play['id']
    assert_equal game.worker_without_play.name, worker_without_play['name']
    assert_equal game.worker_without_play.location.name, worker_without_play['location']
  end
end
