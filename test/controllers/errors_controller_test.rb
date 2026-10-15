require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should render the not found page with a 404 status" do
    get "/not_found"
    assert_response :not_found
    assert_select "h1", /not found/
    assert_select "meta[name=robots][content='noindex, nofollow']"
  end
end
