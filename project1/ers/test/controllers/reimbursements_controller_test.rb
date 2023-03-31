require "test_helper"

class ReimbursementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reimbursements_index_url
    assert_response :success
  end

  test "should get create" do
    get reimbursements_create_url
    assert_response :success
  end

  test "should get sow" do
    get reimbursements_sow_url
    assert_response :success
  end

  test "should get update" do
    get reimbursements_update_url
    assert_response :success
  end

  test "should get delete" do
    get reimbursements_delete_url
    assert_response :success
  end
end
