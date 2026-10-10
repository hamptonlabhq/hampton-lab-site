require "application_system_test_case"

class BlogsTest < ApplicationSystemTestCase
  setup do
    @blog = blogs(:one)
  end

  test "visiting the index" do
    visit blogs_url
    assert_selector "h1", text: "The journey of creating a business that actually works."
  end

  test "should create blog" do
    sign_in
    visit blogs_url
    click_on "New blog"

    fill_in "Title", with: @blog.title
    find("trix-editor").click.set("Hello")
    click_on "Create Blog"

    assert_text "Blog was successfully created"
  end

  test "should update Blog" do
    sign_in
    visit blog_url(@blog)
    click_on "Edit this blog", match: :first

    fill_in "Title", with: "Updated title"
    click_on "Update Blog"

    assert_text "Blog was successfully updated"
  end

  test "should destroy Blog" do
    sign_in
    visit blog_url(@blog)
    click_on "Destroy this blog", match: :first

    assert_text "Blog was successfully destroyed"
  end

  private
    def sign_in
      visit new_session_url
      fill_in "email_address", with: users(:one).email_address
      fill_in "password", with: "password"
      click_on "Sign in"
      assert_no_current_path new_session_path
    end
end
