require "test_helper"

class FounderLetterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get founder_letter_index_url
    assert_response :success
  end
end
