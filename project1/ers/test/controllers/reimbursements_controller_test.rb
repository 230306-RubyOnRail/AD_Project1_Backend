require "test_helper"

class ReimbursementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    token = testUser('admin')
    id = testReim(1)
    Rails.logger.info(id)
    get reimbursements_url,
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :success
  end

  test "should not be logged in to get index" do
    get "/reimbursements",
        headers: { Authorization: "Bearer " }, as: :json
    assert_response :unauthorized
  end

  test "should be unauthorized to get index" do
    token = testUser('employee')
    get "/reimbursements",
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :unauthorized
  end

  test "should delete reimbursement" do
    token = testUser('admin')
    reim = reimbursements(:reim1).id
    assert_difference 'Reimbursement.count', -1 do
      delete "/reimbursements/#{reim}",
           headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :ok
    end
  end

  test "should delete owned reimbursement" do
    #token = testUser('admin')
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim2).id
    assert_difference 'Reimbursement.count', -1 do
      delete "/reimbursements/#{reim}",
             headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :ok
    end
  end

  test "should not delete unowned reimbursement" do
    #token = testUser('admin')
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim1).id
    assert_no_difference 'Reimbursement.count' do
      delete "/reimbursements/#{reim}",
             headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :unauthorized
    end
  end

  # test "should destroy user" do
  #   user = users(:one)
  #   assert_difference 'User.count', -1 do
  #     delete user_url(user)
  #   end
  # end
end
