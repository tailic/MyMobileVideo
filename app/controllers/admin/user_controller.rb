class Admin::UserController < ApplicationController
layout 'admin'
  load_and_authorize_resource
  
  def index
    @users = User.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @users.to_json(:only => [ :id,
                                                             :email,
                                                             :name,
                                                             :current_sign_in_at,
                                                             :current_sign_in_ip,
                                                             :role]) 
                  }
    end
  end
  
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @users.to_json(:only => [ :id,
                                                             :email,
                                                             :name,
                                                             :current_sign_in_at,
                                                             :current_sign_in_ip,
                                                             :role]) 
                  }
    end
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render :json => @user.to_json(:only => [ :id,
                                                             :email,
                                                             :name,
                                                             :current_sign_in_at,
                                                             :current_sign_in_ip,
                                                             :role])
		  }
    end
  end
  
  
  
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.json  { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User."
      redirect_to root_path
    else
      render :action => 'edituser'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.delete
      flash[:notice] = "Successfully deleted User."
      redirect_to admin_root_path
    end
  end

  
end
