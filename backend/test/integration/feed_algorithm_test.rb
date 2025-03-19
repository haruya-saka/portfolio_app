require "test_helper"

class FeedAlgorithmTest < ActionDispatch::IntegrationTest
  setup do
    # ユーザーのサインアップ（既存のUserモデルのアルゴリズムを利用）
    user_params = {
      name: "テストユーザー",
      email_address: "testuser@example.com",
      password: "password", 
      password_confirmation: "password"
    }
    post "/users", params: { user: user_params }
    @user = User.last

    # 作成したユーザーでログイン
    post "/login", params: { session: { email_address: "testuser@example.com", password: "password" } }
    # 必要に応じてリダイレクト先を追跡
    follow_redirect! if response.redirect?
    
    # 他のユーザーや作品データの作成
    @other_user1 = users(:user_2)
    @other_user2 = users(:user_3)
    @work1 = Work.create!(title: "Work 1", description: "作品1", user: @other_user1, created_at: 5.minutes.ago)
    @work2 = Work.create!(title: "Work 2", description: "作品2", user: @other_user2, created_at: 4.minutes.ago)
    @work3 = Work.create!(title: "Work 3", description: "作品3", user: @other_user2, created_at: 3.minutes.ago)

    Activity.create!(performer: @user, target: @work1, target_type: "Work", activity_type: "favorite")
    Activity.create!(performer: @user, target: @work2, target_type: "Work", activity_type: "favorite")
    
    InterestingScore.create!(subject_user: @user, target_user: @other_user1, score: 7)
    InterestingScore.create!(subject_user: @user, target_user: @other_user2, score: 10)
  end

  test "feed algorithm orders feed items by interesting score and favorites" do
    get "/feed"
    json = JSON.parse(response.body)
    work_ids = json.map { |w| w["id"] }
    expected_order = [@work3.id, @work2.id, @work1.id]
    assert_equal expected_order, work_ids, "作品のフィード順序が正しくありません"
  end
end