# test/integration/users_signup_test.rb
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                          email_address: "example.com",
                                          password: "foo",
                                          password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    # レスポンスボディにredirect_urlが含まれているか
    json = JSON.parse(response.body)
    assert_equal signup_path, json["redirect_url"], "Expected redirect_url to be signup_path"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "Test Man",
                                          email_address: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    assert_response :created
    # レスポンスボディにredirect_urlが含まれているか
    json = JSON.parse(response.body)
    assert json["redirect_url"], "Expected redirect_url in response JSON"
  end
end