require_relative '../../lib/tasks/completable'

class ReimbursementList < ApplicationRecord
  include Completable
  belongs_to :user
  has_many :reimbursements, dependent: :destroy
  validates :title, presence: true

  def completed?
    reimbursements.all?(&:completed?)
  end
end
