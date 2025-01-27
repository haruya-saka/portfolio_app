require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email_address: "test@example.com", password: "password", password_confirmation: "password")
  end

  test "should get new" do
    get new_session_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    post session_path, params: { session: { email_address: "test@example.com", password: "password" } }
    assert_redirected_to root_path
  end

  test "should not create session with invalid credentials" do
    post session_path, params: { session: { email_address: "test@example.com", password: "wrongpassword" } }
    assert_redirected_to new_session_path
    follow_redirect!
    assert_select "div.alert", "Try another email address or password."
  end

  test "should destroy session" do
    post session_path, params: { session: { email_address: "test@example.com", password: "password" } }
    delete logout_path
    assert_redirected_to new_session_path
  end
end