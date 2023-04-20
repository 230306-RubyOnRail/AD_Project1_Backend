# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def testUser(role)
      user = User.create(name: 'Test User', email: 'test@revature.net', password: 'password', role:)
      JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_token_secret, 'HS256')
    end

    def testReim(user_id)
      reim = Reimbursement.create(expense_type: 'Test', date_of_expense: 1, status: 'Pending', user_id:)
      reim.id
    end
  end
end
