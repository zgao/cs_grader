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
  validates :visible, presence: true

  def dead
    self.due_date < DateTime.now
  end

  def user_solution_state(user)
    ret = SolutionState.where(user_id: user.id, problem_id: self.id)
    ret.nil? ? nil : ret.first
  end

private

  def initialize_defaults
    self.visible = false
    self.save!
  end
end
