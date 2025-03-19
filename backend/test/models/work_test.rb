require "test_helper"

class WorksTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_1) # フィクスチャを利用
  end

  test "visiting the index" do
    assert @user.present?
  end
end