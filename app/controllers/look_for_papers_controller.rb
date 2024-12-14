class LookForPapersController < ApplicationController
  def show
    @user = current_user
    @look_for_papers = LookForPaper.where(user_id: current_user.id).order(created_at: :desc)
    @look_for_paper = LookForPaper.new
  end

  def create
    @user = current_user
    mission = UserMission.find_by(user_id: current_user.id, mission_id: 3, completed: false)
    look_for_paper = LookForPaper.new(look_for_paper_params)
    return unless look_for_paper.save

    mission.update(completed: true) if mission
    redirect_to look_for_paper_path(@user)
  end

  private

  def look_for_paper_params
    params.require(:look_for_paper).permit(:look_for_paper, :journal, :search_word).merge(user_id: current_user.id)
  end
end
