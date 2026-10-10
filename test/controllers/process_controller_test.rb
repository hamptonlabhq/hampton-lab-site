require "test_helper"

class ProcessControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get process_index_url
    assert_response :success
  end
end
