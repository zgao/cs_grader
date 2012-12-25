class Request < ActiveRecord::Base
  attr_accessible :cs_class
  attr_protected :user

  belongs_to :user
  belongs_to :cs_class

  validates :user_id, presence: true
  validates :cs_class_id, presence: true

private

end
