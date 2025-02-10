require "application_system_test_case"

class WorksTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @work = works(:one)
    sign_in @user
  end

  test "visiting the index" do
    visit user_works_path(@user)
    assert_selector "h1", text: "#{@user.name}'s Works"
    assert_selector "h2", text: @work.title
    assert_selector "p", text: @work.description
    assert_selector "img[src*='sample_image.png']"
  end
end