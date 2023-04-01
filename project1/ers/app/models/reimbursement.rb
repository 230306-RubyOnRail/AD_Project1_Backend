require_relative '../../lib/tasks/completable'

class Reimbursement < ApplicationRecord
  include Completable

  belongs_to :reimbursement_list
  has_one :user, through: :reimbursement_list
  validates :title, presence: true
  validates :description, presence: true

  def completed?
    completed
  end
end
