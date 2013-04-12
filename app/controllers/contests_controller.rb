# -*- encoding : utf-8 -*-
class ContestsController < ApplicationController
  load_and_authorize_resource

  def index
    @contests = Contest.all
    respond_with(@contests)
  end

  def show
    @contest = Contest.find(params[:id])
    respond_with(@contest)
  end

  def new
    @contest = Contest.new
    respond_with(@contest)
  end

  def edit
    @contest = Contest.find(params[:id])
  end

  def create
    @contest = Contest.new(params[:contest])
    @contest.save
    respond_with(@contest)
  end

  def update
    @contest = Contest.find(params[:id])
    @contest.update_attributes(params[:contest])
    respond_with(@contest)
  end

  def destroy
    @contest = Contest.find(params[:id])
    @contest.destroy
    respond_with(@contest)
  end
end
