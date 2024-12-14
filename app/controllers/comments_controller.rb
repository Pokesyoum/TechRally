class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    return unless comment.save

    mission = UserMission.find_by(user_id: current_user.id, mission_id: 2, completed: false)
    mission.update(completed: true) if mission
    redirect_to "/rallies/#{comment.rally.id}"
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, rally_id: params[:rally_id])
  end
end
