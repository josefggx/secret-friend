require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include GameAsserts
  include GamesControllerSupport

  test 'should get all games on index' do
    get_games_index

    assert_response :success
    assert_equal Game.all.size, response_data.size, 'Index games'
  end

  test 'should create a game on create with valid params' do
    params = game_params

    post_game_create(params)

    assert_response :created
    game_response_asserts
  end

  test 'should not create a game with invalid params' do
    params = invalid_game_params

    post_game_create(params)

    assert_response :unprocessable_entity
    assert_equal 'Game', response_error['object']
    assert_includes response_error['message'],
                    I18n.t('activerecord.errors.models.game.attributes.year_game.in', count: (2023..2032))
  end

  private

  def get_games_index
    get games_path
  end

  def post_game_create(params = {})
    post games_path params: params
  end
end
