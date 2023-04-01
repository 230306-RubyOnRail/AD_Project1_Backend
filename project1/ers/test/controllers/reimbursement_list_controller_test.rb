require "test_helper"

class ReimbursementListControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get reimbursement_list_create_url
    assert_response :success
  end

  test "should get show" do
    get reimbursement_list_show_url
    assert_response :success
  end

  test "should get update" do
    get reimbursement_list_update_url
    assert_response :success
  end

  test "should get delete" do
    get reimbursement_list_delete_url
    assert_response :success
  end
end
