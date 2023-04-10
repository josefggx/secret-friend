require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @location = locations(:location_one)
    @worker_one = workers(:worker_one)
    @worker_two = workers(:worker_two)
  end

  test 'worker database columns should match expected schema' do
    expected_columns = {
      id: [:integer, false],
      name: [:string, false],
      location_id: [:integer, false],
      year_in_work: [:string, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Worker.columns.each do |column|
      assert_column_match(column, expected_columns, Worker.name)
    end
  end

  test 'belongs_to :location association' do
    assert_equal @location, @worker_one.location, 'association between worker and location'
  end

  test 'has_many :couples_as_first_worker association' do
    assert_equal 1, @worker_one.couples_as_first_worker.size,
                 'association between worker and couples as first worker'
  end

  test 'has_many :couples_as_second_worker association' do
    assert_equal 1, @worker_two.couples_as_second_worker.size,
                 'association between worker and couples as first worker'
  end

  test 'has_many :couples association' do
    assert_instance_of Couple, @worker_one.couples.new
    assert_equal 2, @worker_one.couples.size, 'association between worker and couples'
  end

  test 'has_many :games_without_play association' do
    assert_equal 1, @worker_one.games_without_play.size, 'association between worker and games without play'
  end

  test 'location_id index should exists in worker table' do
    indexes = ::ActiveRecord::Base.connection.indexes(Worker.table_name)
    matched_index = indexes.detect { |each| each.columns == ['location_id'] }

    assert_equal true, matched_index.present?, 'location_id index exist in worker table'
  end

  test 'should create a new worker with valid attributes' do
    assert_difference 'Worker.count', 1 do
      Worker.create(name: 'Valid worker', location_id: @location.id)
    end
  end

  test 'worker should be invalid without a name' do
    @worker_one.name = nil

    assert_not @worker_one.valid?
    assert_includes @worker_one.errors[:name], I18n.t('activerecord.errors.models.worker.attributes.name.blank')
  end

  test 'should be invalid with a name that contains non-alphanumeric characters' do
    @worker_one.name = 'Inv@lid Wørker!@@'

    assert_not @worker_one.valid?
    assert_includes @worker_one.errors[:name], I18n.t('activerecord.errors.models.worker.attributes.name.invalid')
  end

  test 'should be invalid with a name shorter than 3 characters' do
    @worker_one.name = 'T'

    assert_not @worker_one.valid?
    assert_includes @worker_one.errors[:name], I18n.t('activerecord.errors.messages.too_short', count: 3)
  end

  test 'should be invalid with a name longer than 30 characters' do
    @worker_one.name = 'T' * 31

    assert_not @worker_one.valid?
    assert_includes @worker_one.errors[:name], I18n.t('activerecord.errors.messages.too_long', count: 30)
  end

  test 'should be invalid without a location' do
    @worker_one.location_id = nil

    assert_not @worker_one.valid?
    assert_includes @worker_one.errors[:location_id], I18n.t('activerecord.errors.messages.blank')
  end

  test 'should be invalid with a location that does not exist' do
    @worker_one.location_id = 'An ID that does not exist'

    assert_not @worker_one.valid?
    assert_includes @worker_one.errors[:location],
                    I18n.t('activerecord.errors.models.worker.attributes.location.required')
  end

  test 'find_partner_for_year should find partner for X year' do
    partner = @worker_one.find_partner_for_year(2023)
    assert_equal @worker_two, partner
  end

  test 'find_restricted_partners_ids should find restricted partner ids' do
    restricted_ids = @worker_one.find_restricted_partners_ids(2024)
    assert_includes restricted_ids, @worker_two.id
  end

  test 'order_by_without_play_first should order workers by without play first' do
    workers = Worker.order_by_without_play_first([@worker_one.id, @worker_two.id])
    assert_equal @worker_one, workers.first
    assert_equal @worker_two, workers.second
  end
end
