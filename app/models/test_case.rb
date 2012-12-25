class TestCase < ActiveRecord::Base
  attr_accessible :input, :output
  attr_protected :problem

  has_attached_file :input
  has_attached_file :output

  belongs_to :problem

  validates :input, attachment_presence: true
  validates :output, attachment_presence: true
  validates :problem_id, presence: true

private

end
