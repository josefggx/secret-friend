require 'test_helper'

class GameCreatorTest < ActiveSupport::TestCase
  def setup
    @worker_one = workers(:worker_one)
    @worker_two = workers(:worker_two)
    @game_one = games(:game_one)
    @game_two = games(:game_two)
  end

  test 'should create a new new_game with valid attributes' do
    assert_difference 'Game.count', 1 do
      new_game = GameCreator.new({ year_game: 2024 }).create_game

      assert new_game.valid?, 'Expected new_game to be valid'
      assert_equal new_game.year_game, 2024, 'Expected new_game year to match input params'
      assert new_game.save, 'Expected new_game to be saved'
    end
  end

  test 'should not create new_game with invalid attributes' do
    assert_no_difference 'Game.count' do
      new_game = GameCreator.new({ year_game: 'invalid' }).create_game

      assert_not new_game.valid?, 'Expected new_game to be invalid'
      assert_not new_game.save, 'Expected new_game not to be saved'
    end
  end

  test 'should be invalid when there are less than two workers available' do
    Game.destroy_all
    Worker.destroy_all

    new_game = GameCreator.new({ year_game: 2023 }).create_game

    assert_not new_game.valid?
  end

  test 'should be invalid when the year is invalid' do
    new_game = GameCreator.new({ year_game: 222 }).create_game

    assert_not new_game.valid?
  end

  test 'should assign worker without play when there are an odd number of workers' do
    new_game = GameCreator.new({ year_game: 2027 }).create_game

    assert_not_nil new_game.worker_without_play, 'Expected new_game to have worker without play'
  end

  test 'should generate valid couples for the available workers' do
    Worker.create(name: 'Test Worker 4', location_id: locations(:location_one).id)
    new_game = GameCreator.new({ year_game: 2027 }).create_game

    assert_not_empty new_game.couples, 'Expected new_game to have couples'
    assert new_game.couples.all?(&:valid?), 'Expected all couples to be valid'
    assert_equal new_game.couples.uniq.length, 2, 'Expected all couples to be unique'
  end

  test 'should generate different couples from other years' do
    new_game = GameCreator.new({ year_game: 2024 }).create_game

    new_game.couples.each do |couple|
      game_one_couples_pairs = @game_one.couples.map { |c| [c.first_worker, c.second_worker].sort }
      game_two_couples_pairs = @game_two.couples.map { |c| [c.first_worker, c.second_worker].sort }

      assert_not_includes game_one_couples_pairs, [couple.first_worker, couple.second_worker].sort,
                          "Couple #{couple.id} from new_game should not match any couple from game_one"
      assert_not_includes game_two_couples_pairs, [couple.first_worker, couple.second_worker].sort,
                          "Couple #{couple.id} from new_game should not match any couple from game_two"
    end
  end

  test 'should not repeat the worker without play in consecutive new_game years' do
    worker_without_play_last_year = @game_one.worker_without_play
    worker_without_play_next_year = @game_two.worker_without_play

    new_game = GameCreator.new({ year_game: 2024 }).create_game

    assert_not_equal new_game.worker_without_play, worker_without_play_last_year
    assert_not_equal new_game.worker_without_play, worker_without_play_next_year
    assert_equal new_game.worker_without_play, workers(:worker_two)
  end

  test 'should be invalid when couples is empty' do
    new_game = GameCreator.new({ year_game: 2025 }).create_game
    new_game.couples = []

    assert_not new_game.valid?
  end

  test 'should not be valid when not enough couples are generated' do
    Game.destroy_all
    Couple.destroy_all
    Worker.destroy_all

    Worker.create(name: 'Test worker 1', location_id: locations(:location_one).id)
    Worker.create(name: 'Test worker 2', location_id: locations(:location_two).id)

    game_one = GameCreator.new({ year_game: 2023 }).create_game

    assert game_one.valid?, 'Expected game_one to be valid'
    assert game_one.save, 'Expected game_one to be saved'

    game_two = GameCreator.new({ year_game: 2024 }).create_game

    assert_not game_two.valid?, 'Expected game_two to be invalid'
  end

  test 'find_and_order_all_workers returns workers ordered by those without a play in other games first' do
    expected_workers_order = [@game_one.worker_without_play, @game_two.worker_without_play] | Worker.all.to_a

    assert_equal expected_workers_order,
                 GameCreator.new({ year_game: 2024 }).send(:find_and_order_all_workers)
  end

  test 'actual_year returns the correct year from game_params' do
    new_game = GameCreator.new({ year_game: 2024 })
    assert_equal 2024, new_game.send(:actual_year)
  end

  test 'last_without_play_id returns the id of the worker without play last year' do
    new_game = GameCreator.new({ year_game: 2024 })
    assert_equal @game_one.worker_without_play.id, new_game.send(:last_without_play_id)

    another_new_game = GameCreator.new({ year_game: 2032 })
    assert_nil another_new_game.send(:last_without_play_id)
  end

  test 'next_without_play_id returns the id of the worker without play next year' do
    new_game = GameCreator.new({ year_game: 2024 })
    assert_equal @game_two.worker_without_play.id, new_game.send(:next_without_play_id)

    another_new_game = GameCreator.new({ year_game: 2032 })
    assert_nil another_new_game.send(:next_without_play_id)
  end
end
