class CsClass < ActiveRecord::Base
  attr_accessible :description, :name, :course_id

  has_many :problems

  has_and_belongs_to_many :users

  validates :description, presence: true, length: { maximum: 3000 }
  validates :name, presence: true, length: { maximum: 20 }
  validates :course_id, presence: true

  def has_user(user)
    self.users.where(id: user.id).count >= 1
  end

  def visible_problems(user)
    user.admin? ? self.problems : self.problems.where(visible: true)
  end

  def current_problems(user)
    ret = self.problems.where('due_date >= ?', DateTime.now)
    user.admin? ? ret : ret.where(visible: true)
  end

  def previous_problems(user)
    ret = self.problems.where('due_date < ?', DateTime.now)
    user.admin? ? ret : ret.where(visible: true)
  end

private

end
