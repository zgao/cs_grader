class CsClassesController < ApplicationController
  before_filter :initialize_cs_class, except: [:index, :join, :new, :create]
  before_filter :require_login
  before_filter :require_admin_without_join, only: [:show]
  before_filter :require_admin, except: [:index, :show, :join]
  before_filter :require_not_admin, only: [:join]

  def index
    @cs_classes = CsClass.all
    @valid_classes_ids = current_user.cs_classes.collect {|x| x.id}

    respond_to do |format|
      format.html
      format.json { render json: @cs_classes }
    end
  end

  def show
    @current_problems = @cs_class.current_problems(current_user)
    @previous_problems = @cs_class.previous_problems(current_user)
    @current_solutions = Hash[*(@current_problems.collect {|x| [x.id, x.user_solution_state(current_user)]}.flatten)]
    @previous_solutions = Hash[*(@previous_problems.collect {|x| [x.id, x.user_solution_state(current_user)]}.flatten)]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cs_class }
    end
  end

  def join
    @cs_class = CsClass.find(params[:cs_class_id])
    @request = current_user.requests.new(cs_class: @cs_class)
    @request.save!

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'A request has been made to join the class.' }
      format.json { render json: @request }
    end
  end

  def new
    @cs_class = CsClass.new

    respond_to do |format|
      format.html
      format.json { render json: @cs_class }
    end
  end

  def edit
  end

  def create
    @cs_class = CsClass.new(params[:cs_class])

    respond_to do |format|
      if @cs_class.save
        format.html { redirect_to @cs_class, notice: 'Class was successfully created.' }
        format.json { render json: @cs_class, status: :created, location: @cs_class }
      else
        format.html { render 'new' }
        format.json { render json: @cs_class.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cs_class.update_attributes(params[:cs_class])
        format.html { redirect_to @cs_class, notice: 'Class was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render 'edit' }
        format.json { render json: @cs_class.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cs_class.destroy

    respond_to do |format|
      format.html { redirect_to cs_classes_url }
      format.json { head :no_content }
    end
  end

private

  def initialize_cs_class
    @cs_class = CsClass.find(params[:id])
  end

  def require_login
    redirect_to root_url unless user_signed_in?
  end

  def require_admin_without_join
    redirect_to cs_classes_url unless (current_user.admin? or @cs_class.has_user(current_user))
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
  end

  def require_not_admin
    redirect_to root_url if current_user.admin?
  end
end
