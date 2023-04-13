require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should create user" do
    assert_difference 'User.count', 1 do
      post "/signup/employee", params: {name: 'Test Me', email: 'testme@revature.net', password: 'password'}, as: :json
      assert_response :created
    end
  end

  test "should not create user" do
    assert_no_difference 'User.count' do
      post "/signup/employee", params: {email: 'testme@revature.net', password: 'password'}, as: :json
      assert_response :unprocessable_entity
    end
  end

  test "should create admin" do
    token = testUser('admin')
    assert_difference 'User.count', 1 do
      post "/signup/admin", params: {name: 'Test Me', email: 'testme@revature.net', password: 'password'},
           headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :created
    end
  end

  test "should not create admin" do
    token = testUser('admin')
    assert_no_difference 'User.count' do
      post "/signup/admin", params: {email: 'testme@revature.net', password: 'password'},
           headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :unprocessable_entity
    end
  end

  test "should be unauthorized to create admin" do
    token = testUser('employee')
    assert_no_difference 'User.count' do
      post "/signup/admin", params: {email: 'testme@revature.net', password: 'password'},
           headers: { Authorization: "Bearer #{token}" }, as: :json
      assert_response :unauthorized
    end
  end
end
