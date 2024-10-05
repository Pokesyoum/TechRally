class RalliesController < ApplicationController
  def index
    @rallies = Rally.all
  end

  def new
    @rally = Rally.new
  end

  def show
    @rally = Rally.find(params[:id])
  end
end
