class AllSolutionsController < ApplicationController
  before_filter :require_login

  def index
    @problems = current_user.cs_classes.collect {|x| x.problems}.flatten
    @solutions = @problems.collect do |x|
      if current_user.admin?
        x.solutions.order('test_cases_passed desc').first
      else
        x.solutions.where(:user_id => current_user.id).order('test_cases_passed desc').first
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @solutions }
    end
  end

private

  def require_login
    redirect_to root_url unless user_signed_in?
  end
end
