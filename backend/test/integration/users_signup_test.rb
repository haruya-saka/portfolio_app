# test/integration/users_signup_test.rb
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "TestMan",
                                          email_address: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'sessions/new'
    assert_select "div.notice", "Signed up successfully"
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "TestMan",
                                          email_address: "user@invalid",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    assert_template 'registrations/new'
    assert_select "div.alert", "Email address is not a valid email"
  end
end