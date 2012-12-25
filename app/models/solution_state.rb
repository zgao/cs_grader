class SolutionState < ActiveRecord::Base
  attr_protected :user, :problem, :solution, :test_cases_passed, :test_cases_total, :comments

  belongs_to :user
  belongs_to :problem
  belongs_to :solution

  after_initialize :initialize_defaults

  def test_cases_ratio
    "#{self.test_cases_passed} / #{self.test_cases_total}"
  end

private

  def initialize_defaults
    self.test_cases_passed ||= 0
    self.test_cases_total ||= self.problem.test_cases.count
  end
end
