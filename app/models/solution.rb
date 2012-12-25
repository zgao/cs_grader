class Solution < ActiveRecord::Base
  attr_accessible :file, :problem
  attr_protected :validated, :test_cases_passed, :tested, :comments, :user

  has_attached_file :file

  belongs_to :user
  belongs_to :problem

  after_create :initialize_defaults
  after_create :test_solution

  validates :file, attachment_presence: true
  validates :user_id, presence: true
  validates :problem_id, presence: true

  def test_case_ratio
    "#{self.test_cases_passed} / #{self.problem.test_cases.count}"
  end

  def update_maximums
    unless self.problem.dead
      solution_state = SolutionState.where(user_id: self.user.id, problem_id: self.problem.id)
      if solution_state.nil?
        solution_state = self.problem.solution_states.new
        solution_state.user = self.user
        solution_state.solution = self
        solution_state.test_cases_passed = self.test_cases_passed
        solution_state.comments = self.comments
        solution_state.save
      else
        solution_state = solution_state.first
        if self.test_cases_passed > solution_state.test_cases_passed
          solution_state.solution = self
          solution_state.test_cases_passed = self.test_cases_passed
          solution_state.comments = self.comments
          solution_state.save
        end
      end
    end
  end

private

  def initialize_defaults
    self.comments ||= ''
    self.test_cases_passed ||= 0
    self.tested ||= false
    self.validated ||= false
    self.save!
  end

  def test_solution
    Delayed::Job.enqueue(GradingJob.new(self))
  end
end
