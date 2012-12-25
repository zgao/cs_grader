class TestCasesController < ApplicationController
  before_filter :initialize_parents
  before_filter :initialize_test_case, :only => [:show, :destroy]
  before_filter :require_login_and_dead_problem
  before_filter :require_admin, :only => [:create, :destroy]

  def index
    @test_cases = TestCase.where(:cs_class_id => @cs_class.id, :problem_id => @problem.id)

    respond_to do |format|
      format.html
      format.json { render :json => @test_cases }
    end
  end

  def show
    input_file = File.foreach(@test_case.input.path).take(11)
    @input_lines = if input_file.size == 11
                     input_file[0...10] + ["..."]
                   else
                     input_file
                   end
    output_file = File.foreach(@test_case.output.path).take(11)
    @output_lines = if output_file.size == 11
                      output_file[0...10] + ["..."]
                    else
                      output_file
                    end

    respond_to do |format|
      format.html
      format.json { render :json => @test_case }
    end
  end

  def create
    @test_case = @problem.test_cases.new(params[:test_case])

    respond_to do |format|
      if @test_case.save
        format.html { redirect_to cs_class_problem_test_case_url(@cs_class, @problem, @test_case),
                      :notice => 'Test case successfully uploaded.' }
        format.json { render :json => @test_case }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @test_case.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @test_case.destroy

    respond_to do |format|
      format.html { redirect_to cs_class_problem_test_cases_url(@cs_class, @problem) }
      format.json { head :no_content }
    end
  end

private

  def initialize_parents
    @cs_class = CsClass.find(params[:cs_class_id])
    @problem = Problem.find(params[:problem_id])
  end

  def initialize_test_case
    @test_case = TestCase.find(params[:id])
  end

  def require_login_and_dead_problem
    problem = Problem.find(params[:problem_id])
    redirect_to new_user_session_url unless (user_signed_in? and (current_user.admin? or problem.dead))
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
  end
end
