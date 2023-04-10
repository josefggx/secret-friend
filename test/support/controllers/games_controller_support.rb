# frozen_string_literal: true

module GamesControllerSupport
  def game_params
    {
      game: {
        year_game: '2027'
      }
    }
  end

  def invalid_game_params
    {
      game: {
        year_game: '2010'
      }
    }
  end

  def create_game_valid_keys
    %w[year_game worker_without_play all_games]
  end
end
