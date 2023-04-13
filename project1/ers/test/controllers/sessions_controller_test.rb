require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should create token with valid credentials" do
    user = users(:user1)
    post "/auth/login", params: { email: user.email, password: "user_john"}, as: :json
    assert_response :created
    assert_not_nil response.parsed_body["token"]
    assert_equal user.email, response.parsed_body["email"]
    assert_equal user.name, response.parsed_body["name"]
    assert_equal user.role, response.parsed_body["role"]
  end
end
