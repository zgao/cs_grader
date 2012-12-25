class SolutionsController < ApplicationController
  before_filter :initialize_parents
  before_filter :initialize_solution, only: [:show]
  before_filter :require_login
  before_filter :require_admin_on_foreign, only: [:show]

  def index
    @solutions = Solution.where(:user_id => current_user.id, :problem_id => params[:problem_id])
    @test_cases_count = @problem.test_cases.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @solutions }
    end
  end

  def show
    @solution = Solution.find(params[:id])
    if @solution.user_id != current_user.id
      if current_user.admin?
        @user = @solution.user
      else
        redirect_to cs_class_problem_solutions_url(@problem.cs_class, @problem)
        return
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @solution }
    end
  end

  def create
    @solution = @problem.solutions.new(params[:solution])
    @solution.user = current_user

    respond_to do |format|
      if @solution.save
        format.html { redirect_to cs_class_problem_solution_url(@cs_class, @problem, @solution),
                      notice: 'Solution was successfully created.' }
        format.json { render json: @solution, status: :created, location: @solution }
      else
        format.html { redirect_to cs_class_problem_url(@cs_class, @problem) } #no notice, should be self-explanatory
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def require_login
    redirect_to new_user_session_url unless user_signed_in?
  end

  def initialize_parents
    @cs_class = CsClass.find(params[:cs_class_id])
    @problem = Problem.find(params[:problem_id])
  end

  def initialize_solution
    @solution = Solution.find(params[:id])
  end

  def require_admin_on_foreign
    if ((@solution.user.id != current_user.id) and not current_user.admin?)
      redirect_to cs_class_problem_solutions_url(@cs_class, @problem)
    end
  end
end
