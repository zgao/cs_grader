class AdminController < ApplicationController
  before_filter :require_admin

  def user_list
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def user_approval
    @users = User.where(approved: false)

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def approve_user
    @user = User.find(params[:id])
    @user.approved = true
    @user.save!

    respond_to do |format|
      format.html { redirect_to action: 'user_approval', controller: 'admin' }
    end
  end

  def delete_user
    @user = User.find(params[:user_id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to action: 'user_list', controller: 'admin' }
    end
  end

  def class_approval
    @requests = Request.all

    respond_to do |format|
      format.html
      format.json { render json: @requests }
    end
  end

  def class_approved
    @user = User.find(params[:id])
    @class = CsClass.find(params[:cs_class_id])
    Request.where(user_id: @user.id, cs_class_id: @class.id).each {|x| x.destroy}
    @class.users << @user

    respond_to do |format|
      format.html { redirect_to action: 'class_approval', controller: 'admin' }
    end
  end

private

  def require_admin
    redirect_to root_url unless (user_signed_in? and current_user.admin?)
  end
end
