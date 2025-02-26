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
    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal user_path(User.last), json_response['redirect_url']
    assert_equal "TestMan", json_response['user']['name']
    assert_equal "test@example.com", json_response['user']['email_address']
  end

  test "should not create user with invalid parameters" do
    assert_no_difference('User.count') do
      post signup_path, params: { user: { name: "TestMan", email_address: "test@example.com", password: "password", password_confirmation: "wrongpassword" } }
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_match /Password confirmation doesn't match Password/, json_response['alert']
  end
end