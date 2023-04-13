require "test_helper"

class ReimbursementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    token = testUser('admin')
    get "/reimbursements",
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

  # test "should delete reimbursement" do
  #   token = testUser('admin')
  #   id = testReim(1)
  #   delete "/reimbursements/#{id}",
  #          headers: { Authorization: "Bearer #{token}" }, as: :json
  #   assert_response :ok
  # end

  # test "should get create" do
  #   get reimbursements_create_url
  #   assert_response :success
  # end
  #
  # test "should get show" do
  #   get reimbursements_show_url
  #   assert_response :success
  # end
  #
  # test "should get update" do
  #   get reimbursements_update_url
  #   assert_response :success
  # end
  #
  # test "should get delete" do
  #   get reimbursements_delete_url
  #   assert_response :success
  # end
end
