class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
  def show
    @rallies = current_user.rallies
    @user_missions = current_user.user_missions.where(completed: false)
  end
end
