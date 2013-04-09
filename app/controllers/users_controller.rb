# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability, :index).
      page(params[:page] || 1).per(15)
    if params[:search]
      @users = @users.search(params[:search])
    end
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])

    respond_with(@user)
  end

  def new
    @user = User.new
    @person_id = params[:person_id]
    @user.roles << Role.standart
    respond_with(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.activated_at = Time.now
    @user.activated_by = current_user
    standart_roles = Role.standart
    @user.roles << standart_roles unless @user.roles.include? standart_roles

    @user.save
    respond_with(@user)
  end

  def update
    @user = User.find(params[:id])
    [:password, :password_confirmation].collect{ |p|
      params[:user].delete(p)
    } if params[:user][:password].blank?
    [:person_id].collect{ |p| params[:user].delete(p) }

    @user.update_attributes(params[:user])
    respond_with(@user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.deactivate! current_user

    respond_with(@user)
  end

  def activate
    @user = User.find(params[:id])
    @user.activate! current_user

    respond_with(@user)
  end
end
