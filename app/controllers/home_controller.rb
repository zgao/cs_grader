class HomeController < ApplicationController
  def index
    if user_signed_in?
      @cs_classes = current_user.visible_cs_classes
      @problems = {}
      @cs_classes.each do |cs_class|
        @problems[cs_class] = cs_class.visible_problems(current_user)
      end
    end
    render "index"
  end
end
