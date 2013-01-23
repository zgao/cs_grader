class Problem < ActiveRecord::Base
  attr_accessible :description, :name, :cs_class, :due_date, :time_limit, :visible

  has_many :test_cases
  has_many :solutions
  has_many :solution_states

  belongs_to :cs_class

  after_create :initialize_defaults

  #nothing for description
  validates :name, presence: true, format: { with: /^[A-Za-z0-9_\ ]+$/ }, uniqueness: true
  validates :cs_class_id, presence: true
  validates :due_date, presence: true
  validates :time_limit, presence: true, inclusion: { in: (1..60) }
  validates :visible, inclusion: { in: [true, false] }

  def dead
    self.due_date < DateTime.now
  end

  def user_solution_state(user)
    ret = user.solution_states.where(problem_id: self.id)
    ret.nil? ? nil : ret.first
  end

  def due_date_display
    self.due_date.to_date
  end

  def number_of_solutions
    self.solutions.count
  end

  def number_of_correct_solutions
    self.solutions.where(validated: true).count
  end

  def average_test_cases
    Float(self.solutions.sum(:test_cases_passed)) / self.number_of_solutions
  end

  def success_rate
    100 * Float(self.number_of_correct_solutions) / self.number_of_solutions
  end

  def attempts(user)
    self.solutions.where(user_id: user.id).count
  end

  def solution_exists?(user)
    self.attempts > 0
  end

  def best_try(user)
    if self.user_solution_state(user).nil?
      return 'None'
    else
      return self.user_solution_state(user).test_cases_ratio
    end
  end

  def best_solution(user)
    if self.user_solution_state(user).nil?
      return nil
    else
      return self.user_solution_state(user).solution
    end
  end

  def available_solutions(user)
    if user.admin?
      self.solutions
    else
      self.solutions.where(user_id: user.id)
    end
  end

private

  def initialize_defaults
    self.visible = false
    self.save!
  end
end
