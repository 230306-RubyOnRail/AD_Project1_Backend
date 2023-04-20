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
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim1).id
    assert_no_difference 'Reimbursement.count' do
      delete "/reimbursements/#{reim}",
             headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :unauthorized
    end
  end

  test "should show all reims by user ID" do
    token = testUser('employee')
    get '/reimbursements/showuserreims',
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :ok
  end

  test "should not show all reims by user ID with invalid Token" do
    token = ""
    get '/reimbursements/showuserreims',
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :unauthorized
  end

  test "should show reim by ID" do
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim2).id
    get "/reimbursements/#{reim}",
           headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :ok
  end

  test "should not show reim, when not owned" do
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim1).id
    get "/reimbursements/#{reim}",
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :unauthorized
  end

  test "should show requested reim as admin" do
    token = testUser('admin')
    reim = reimbursements(:reim2).id
    get "/reimbursements/#{reim}",
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :ok
  end

  test "should update if user owns" do
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim2)
    put "/reimbursements/#{reim.id}",
        params: { date_of_expense: 5, status: "Approved" },
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :ok
  end

  test "should not update if user doesn't own" do
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim1)
    put "/reimbursements/#{reim.id}",
        params: { date_of_expense: 5, status: "Approved" },
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :unauthorized
  end

  test "should update if user is admin" do
    user = users(:user1)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim2)
    put "/reimbursements/#{reim.id}",
        params: { date_of_expense: reim.date_of_expense, status: "Approved" },
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :ok
  end

  test "should not update if form type doesn't match type given" do
    user = users(:user2)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    reim = reimbursements(:reim2)
    put "/reimbursements/#{reim.id}",
        params: { date_of_expense: "date", status: "Approved" },
        headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :unprocessable_entity
  end

  test "should create if a valid user is logged in" do
    token = testUser('employee')
    assert_difference 'Reimbursement.count', 1 do
      post "/reimbursements", params: {date_of_expense: 10, expense_type: "Meals", additional_comments:"Meals for the team", status: "Pending", amount: 100},
           headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :created
    end
  end

  test "should not create reim if user_id's don't match" do
    token = ""
    assert_no_difference 'Reimbursement.count' do
      post "/reimbursements", params: {date_of_expense: 10, expense_type: "Meals", additional_comments:"Meals for the team", status: "Pending", amount: 100},
           headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :unauthorized
    end
  end

  test "should not create if types don't match" do
    token = testUser('employee')
    post "/reimbursements", params: {date_of_expense: "date", expense_type: "Meals", additional_comments:"Meals for the team", status: "Pending", amount: 100},
         headers: { Authorization: "Bearer #{token}" }, as: :json
    assert_response :unprocessable_entity
  end

  test "should fail" do
    get "/reimbursements",
        headers: { Authorization: "Bearer " }, as: :json
    assert_response :success
  end

end

