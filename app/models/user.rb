class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin

  has_many :solutions
  has_many :requests
  has_many :solution_states

  has_and_belongs_to_many :cs_classes

  after_create :initialize_defaults

  def visible_cs_classes
    if self.admin?
      CsClass.all
    else
      self.cs_classes
    end
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

private

  def initialize_defaults
    self.approved ||= false
    self.save!
  end
end
