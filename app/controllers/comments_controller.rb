class CommentsController < ApplicationController
  def create
    comment = Comment.create(comment_params)
    redirect_to "/rallies/#{comment.rally.id}"
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, rally_id: params[:rally_id])
  end
end
