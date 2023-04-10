require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include LocationAsserts
  include LocationsControllerSupport

  test 'should get all locations on index' do
    get_locations_index

    assert_response :success
    assert_equal Location.all.size, response_data.size, 'Index locations'
  end

  test 'should create a location on create with valid params' do
    params = location_params

    post_location_create(params)

    assert_response :created
    location_response_asserts
  end

  test 'should not create a location with invalid params' do
    params = invalid_location_params

    post_location_create(params)

    assert_response :unprocessable_entity
    assert_equal 'Location', response_error['object']
    assert_includes response_error['message'], I18n.t('activerecord.errors.messages.too_short', count: 3)
  end

  private

  def get_locations_index
    get locations_path
  end

  def post_location_create(params = {})
    post locations_path params: params
  end
end
