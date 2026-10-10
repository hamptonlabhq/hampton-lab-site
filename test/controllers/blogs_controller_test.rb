require "test_helper"

class BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blog = blogs(:one)
  end

  test "should get index" do
    get blogs_url
    assert_response :success
  end

  test "should show blog" do
    get blog_url(@blog)
    assert_response :success
  end

  test "should require sign in to get new" do
    get new_blog_url
    assert_redirected_to new_session_url
  end

  test "should get new" do
    sign_in_as users(:one)
    get new_blog_url
    assert_response :success
  end

  test "should create blog" do
    sign_in_as users(:one)
    assert_difference("Blog.count") do
      post blogs_url, params: { blog: { content: "Hello", title: @blog.title } }
    end

    assert_redirected_to blog_url(Blog.last)
  end

  test "should get edit" do
    sign_in_as users(:one)
    get edit_blog_url(@blog)
    assert_response :success
  end

  test "should update blog" do
    sign_in_as users(:one)
    patch blog_url(@blog), params: { blog: { content: "Hello", title: @blog.title } }
    assert_redirected_to blog_url(@blog)
  end

  test "should destroy blog" do
    sign_in_as users(:one)
    assert_difference("Blog.count", -1) do
      delete blog_url(@blog)
    end

    assert_redirected_to blogs_url
  end
end
