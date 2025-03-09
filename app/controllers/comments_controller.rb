class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    return unless comment.save

    user_mission_update
    redirect_to rally_path(comment.rally)
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, rally_id: params[:rally_id])
  end

  def user_mission_update
    mission = UserMission.find_by(user_id: current_user.id, mission_id: 2, completed: false)
    mission.update(completed: true) if mission
  end
end
