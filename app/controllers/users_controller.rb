class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
    @rallies = @user.rallies
    @user_missions = UserMission.where(user_id: current_user.id, completed: false)
  end
end
