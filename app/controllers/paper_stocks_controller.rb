class PaperStocksController < ApplicationController
  def show
    @user = current_user
    @paper_stocks = PaperStock.where(user_id: current_user.id).order(created_at: :desc)
    @paper_stock = PaperStock.new
  end

  def create
    @user = current_user
    mission = UserMission.find_by(user_id: current_user.id, mission_id: 4, completed: false)
    paper_stock = PaperStock.new(paper_stock_params)
    return unless paper_stock.save

    mission.update(completed: true) if mission
    redirect_to paper_stock_path(@user)
  end

  private

  def paper_stock_params
    params.require(:paper_stock).permit(:outline, :paper_url).merge(user_id: current_user.id)
  end
end
