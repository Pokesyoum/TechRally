class LookForPapersController < ApplicationController
  def show
    @user = current_user
    @look_for_papers = LookForPaper.where(user_id: current_user.id)
  end
end
