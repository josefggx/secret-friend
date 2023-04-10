require 'test_helper'

class WorkersControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include WorkerAsserts
  include WorkersControllerSupport

  test 'should get all workers on index' do
    get_workers_index

    assert_response :success
    assert_equal Worker.all.size, response_data.size, 'Index workers'
  end

  test 'should create a worker on create with valid params' do
    params = worker_params

    post_worker_create(params)

    assert_response :created
    worker_response_asserts
  end

  test 'should not create a worker with invalid params' do
    params = invalid_worker_params

    post_worker_create(params)

    assert_response :unprocessable_entity
    assert_equal 'Worker', response_error['object']
    assert_includes response_error['message'], I18n.t('activerecord.errors.messages.too_short', count: 3)
  end

  private

  def get_workers_index
    get workers_path
  end

  def post_worker_create(params = {})
    post workers_path params: params
  end
end
