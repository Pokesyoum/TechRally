class LookForPapersController < ApplicationController
  def show
    @user = current_user
    @look_for_papers = LookForPaper.where(user_id: current_user.id)
    @look_for_paper = LookForPaper.new
  end

  def create
    @user = current_user
    look_for_paper = LookForPaper.create(look_for_paper_params)
    redirect_to look_for_paper_parh(@user)
  end

  private

  def look_for_paper_params
    params.require(:look_for_paper).permit(:look_for_paper, :journal, :search_word).merge(user_id: current_user.id)
  end
end
