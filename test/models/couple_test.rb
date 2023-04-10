require 'test_helper'

class CoupleTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @couple = couples(:couple_one)
  end

  test 'couple database columns should match expected schema' do
    expected_columns = {
      id: [:integer, false],
      first_worker_id: [:integer, false],
      second_worker_id: [:integer, false],
      game_id: [:integer, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Couple.columns.each do |column|
      assert_column_match(column, expected_columns, Couple.name)
    end
  end

  test 'belongs_to :first_worker relation' do
    assert_equal workers(:worker_one), @couple.first_worker, 'relation between couple and first worker'
  end

  test 'belongs_to :second_worker relation' do
    assert_equal workers(:worker_two), @couple.second_worker, 'relation between couple and second worker'
  end

  test 'belongs_to :game relation' do
    assert_equal games(:game_one), @couple.game, 'relation between couple and game'
  end

  test 'index on [:first_worker_id, :second_worker_id] should exist in couple table' do
    indexes = ::ActiveRecord::Base.connection.indexes(Couple.table_name)
    matched_index = indexes.detect { |each| each.columns == %w[first_worker_id second_worker_id game_id] }

    assert matched_index.present?, 'index on [:first_worker_id, :second_worker_id] exists in couple table'
  end

  test 'couple should be invalid without a first worker' do
    @couple.first_worker = nil

    assert_not @couple.valid?
    assert_includes @couple.errors[:first_worker], I18n.t('activerecord.errors.messages.blank')
  end

  test 'couple should be invalid without a second worker' do
    @couple.second_worker = nil

    assert_not @couple.valid?
    assert_includes @couple.errors[:second_worker], I18n.t('activerecord.errors.messages.blank')
  end

  test 'couple should be invalid without a game' do
    @couple.game = nil

    assert_not @couple.valid?
    assert_includes @couple.errors[:game], I18n.t('activerecord.errors.messages.blank')
  end
end
