require 'simplecov'
SimpleCov.start
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def testUser(role)
    user = User.create(name: 'Test User', email: 'test@revature.net', password: 'password', role: role)
    token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    return token
  end

  # def testReim(user_id)
  #   reim = Reimbursement.create(expense_type: 'Test', date_of_expense: 1, status: 'Pending', amount: 10, user_id: user_id)
  #   id = reim.id
  #   return id
  # end
end
