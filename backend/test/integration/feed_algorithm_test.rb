require "test_helper"
 
class FeedAlgorithmTest < ActionDispatch::IntegrationTest
  setup do
    # テストユーザーの作成
    user_params = {
      name: "テストユーザー",
      email_address: "testuser@example.com",
      password: "password", 
      password_confirmation: "password"
    }
    post "/signup", params: { user: user_params }
    puts "DEBUG: User creation response code: #{response.code}"
    @user = User.last
    post "/login", params: { session: { email_address: "testuser@example.com", password: "password" } }
    puts "DEBUG: Login response code: #{response.code}"
    puts "DEBUG: Login response body: #{response.body}"
    follow_redirect! if response.redirect?
    puts "DEBUG: After redirect, current_user id: #{@user.id}"
    
    # 他ユーザー,作品データの作成
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

  # 期待する順序
  # @work3.id（score: 10, created_at: 3minutes_ago）
  # @work2.id (score: 10, created_at: 4minutes_ago)
  # @work1.id (score: 7, created_at: 5minutes_ago)

  test "feed algorithm orders feed items by interesting score and favorites" do
    get "/feed", as: :json
    json = JSON.parse(response.body)
    work_ids = json.map { |w| w["id"] }
    expected_order = [@work3.id, @work2.id, @work1.id]
    filtered_ids = work_ids.select { |id| [@work1.id, @work2.id, @work3.id].include?(id) }
    assert_equal expected_order, filtered_ids, "作品のフィード順序が正しくありません"
  end
end