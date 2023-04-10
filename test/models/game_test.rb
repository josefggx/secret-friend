require 'test_helper'

class GameTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @worker_one = workers(:worker_one)
    @worker_two = workers(:worker_two)
    @game_one = games(:game_one)
  end

  test 'game database columns should match expected schema' do
    expected_columns = {
      id: [:integer, false],
      year_game: [:integer, false],
      workers: [:text, true],
      worker_without_play_id: [:integer, true],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Game.columns.each do |column|
      assert_column_match(column, expected_columns, Game.name)
    end
  end

  test 'has_many :couples association' do
    assert_instance_of Couple, @game_one.couples.new
    assert_equal 2, @game_one.couples.size, 'association between game and couples'
  end

  test 'belongs_to :worker_without_play association' do
    worker_without_play = workers(:worker_three)
    assert_equal worker_without_play,
                 @game_one.worker_without_play, 'association between game and worker without play'
  end

  test 'worker_without_play_id index should exists in game table' do
    indexes = ::ActiveRecord::Base.connection.indexes(Game.table_name)
    matched_index = indexes.detect { |each| each.columns == ['worker_without_play_id'] }

    assert_equal true, matched_index.present?, 'worker_without_play_id index exist in worker table'
  end

  test 'should be valid with valid attributes' do
    game = Game.create(year_game: 2027)
    game.couples << couples(:couple_one)

    assert game.valid?
  end

  test 'game should be invalid without a year_game' do
    @game_one.year_game = nil

    assert_not @game_one.valid?
    assert_includes @game_one.errors[:year_game], I18n.t('activerecord.errors.messages.blank')
  end

  test 'game should be invalid with a year_game that is outside of the 2023-2032 range' do
    @game_one.year_game = 2033

    assert_not @game_one.valid?
    assert_includes @game_one.errors[:year_game],
                    I18n.t('activerecord.errors.models.game.attributes.year_game.in', count: (2023..2032))
  end

  test 'game should be invalid with a year_game that already exists' do
    new_game = Game.new(year_game: @game_one.year_game)

    assert_not new_game.valid?
    assert_includes new_game.errors[:year_game], I18n.t('activerecord.errors.models.game.attributes.year_game.taken')
  end

  test 'game should be invalid without at least two workers' do
    Game.destroy_all
    Worker.destroy_all

    game = Game.new(year_game: 2023)

    assert_not game.valid?
    assert_includes game.errors[:workers], I18n.t('activerecord.errors.models.game.attributes.workers.workers_required')
  end

  test 'game should be invalid without at least one couple' do
    @game_one.couples.destroy_all

    assert_not @game_one.valid?
    assert_includes @game_one.errors[:couples],
                    I18n.t('activerecord.errors.models.game.attributes.couples.couples_required')
  end
end
