require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_1) # フィクスチャを利用
  end

  test "should get new" do
    get new_session_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    post login_path, params: { session: { email_address: @user.email_address, password: 'password' } }
    assert_response :success
  end

  test "should not create session with invalid credentials" do
    post login_path, params: { session: { email_address: @user.email_address, password: 'wrongpassword' } }
    assert_response :unauthorized
  end

  test "should destroy session" do
    post session_path, params: { session: { email_address: "test@example.com", password: "password" } }
    delete logout_path
    assert_redirected_to new_session_path
  end
end