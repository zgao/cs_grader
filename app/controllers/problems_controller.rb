class ProblemsController < ApplicationController
  before_filter :initialize_parents
  before_filter :initialize_problem, except: [:new, :create, :index, :make_visible]
  before_filter :require_login
  before_filter :require_admin_if_invisible, except: [:new, :create, :index]
  before_filter :require_admin, except: [:index, :show]

  def index
    @problems = Problem.where(cs_class_id: @cs_class.id).where('due_date >= ?', DateTime.now)
    @problems = @problems.where(visible: true) unless current_user.admin?

    respond_to do |format|
      format.html
      format.json { render json: @problems }
    end
  end

  def show
    @solution = Solution.new
    @test_case = @problem.test_cases.new

    respond_to do |format|
      format.html
      format.json { render json: @problem }
    end
  end

  def make_visible
    @problem.visible = true
    @problem.save!

    respond_to do |format|
      format.html { redirect_to cs_class_problems_url(@cs_class) }
      format.json { render json: @problem }
    end
  end

  def new
    @problem = Problem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @problem }
    end
  end

  def edit
  end

  def create
    @problem = @cs_class.problems.new(params[:problem])
    @problem.visible = false

    respond_to do |format|
      if @problem.save!
        format.html { redirect_to cs_class_problem_url(@cs_class, @problem), notice: 'Problem was successfully created.' }
        format.json { render json: @problem, status: :created, location: @problem }
      else
        format.html { render 'new' }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @problem.update_attributes(params[:problem])
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @problem.destroy

    respond_to do |format|
      format.html { redirect_to cs_class_problems_url(@cs_class) }
      format.json { head :no_content }
    end
  end

private

  def initialize_parents
    @cs_class = CsClass.find(params[:cs_class_id])
  end

  def initialize_problem
    @problem = Problem.find(params[:id])
  end

  def require_login
    redirect_to new_user_session_url unless user_signed_in?
  end

  def require_admin_if_invisible
    redirect_to cs_class_problems_path(@cs_class) unless (current_user.admin? or @problem.visible)
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
  end
end
