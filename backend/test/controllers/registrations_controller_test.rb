require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should create user with valid parameters" do
    assert_difference('User.count', 1) do
      post signup_path, params: { user: { name: "TestMan", email_address: "test@example.com", password: "password", password_confirmation: "password" } }
    end
    assert_redirected_to new_session_path
    follow_redirect!
    assert_select "div.notice", "Signed up successfully"
  end

  test "should not create user with invalid parameters" do
    assert_no_difference('User.count') do
      post signup_path, params: { user: { name: "TestMan", email_address: "test@example.com", password: "password", password_confirmation: "wrongpassword" } }
    end
    assert_response :success
    assert_select "div.alert", "Password confirmation doesn't match Password"
  end
end