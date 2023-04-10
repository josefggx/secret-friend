require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  include AssertColumnMatch

  def setup
    @location = locations(:location_one)
  end

  test 'location database columns should match expected schema' do
    expected_columns = {
      id: [:integer, false],
      name: [:string, false],
      created_at: [:datetime, false],
      updated_at: [:datetime, false]
    }

    Location.columns.each do |column|
      assert_column_match(column, expected_columns, Location.name)
    end
  end

  test 'has_many :workers relation' do
    assert_equal 1, @location.workers.size, 'relation between location and workers'
  end

  test 'should create a new location with valid attributes' do
    assert_difference 'Location.count', 1 do
      Location.create(name: 'Valid location 123')
    end
  end

  test 'location should be invalid without a name' do
    @location.name = nil

    assert_not @location.valid?
    assert_includes @location.errors[:name], I18n.t('activerecord.errors.messages.blank')
  end

  test 'should be invalid with a name that contains non-alphanumeric characters' do
    @location.name = 'Inv@lid Ïøcation!@@'

    assert_not @location.valid?
    assert_includes @location.errors[:name], I18n.t('activerecord.errors.models.location.attributes.name.invalid')
  end

  test 'should be invalid with a name shorter than 3 characters' do
    @location.name = 'T'

    assert_not @location.valid?
    assert_includes @location.errors[:name], I18n.t('activerecord.errors.messages.too_short', count: 3)
  end

  test 'should be invalid with a name longer than 30 characters' do
    @location.name = 'T' * 31

    assert_not @location.valid?
    assert_includes @location.errors[:name], I18n.t('activerecord.errors.messages.too_long', count: 30)
  end

  test 'should be invalid with a name that already exists' do
    location = Location.new(name: @location.name)

    assert_not location.valid?
    assert_includes location.errors[:name], I18n.t('activerecord.errors.messages.taken')
  end
end
