class RalliesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :edit, :destroy]
  before_action :set_rally, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: :edit

  def index
    @rallies = Rally.where(draft: false).order(created_at: :desc)
  end

  def new
    @rally = Rally.new
  end

  def create
    @rally = Rally.new(rally_params)
    rally_save(@rally)
  end

  def show
    @comments = @rally.comments
    @comment = Comment.new
  end

  def edit
  end

  def update
    rally_save(@rally, update: true)
  end

  def destroy
    @rally.destroy
    redirect_to rally_lists_rallies_path
  end

  def rally_lists
    @rallies = current_user.rallies
  end

  def ranking
    @rally_top_users = Rally.select('user_id, COUNT(user_id) AS user_count')
                            .group(:user_id)
                            .order('user_count DESC')
                            .limit(3)
    @monthly_rally_top_users = Rally.select('user_id, COUNT(user_id) AS user_count')
                                    .where('created_at >= ? AND created_at <= ?', Time.now.beginning_of_month, Time.now.end_of_month)
                                    .group(:user_id)
                                    .order('user_count DESC')
                                    .limit(3)
    @comment_top_users = Comment.select('user_id, COUNT(user_id) AS user_count')
                                .group(:user_id)
                                .order('user_count DESC')
                                .limit(3)
    @monthly_comment_top_users = Comment.select('user_id, COUNT(user_id) AS user_count')
                                        .where('created_at >= ? AND created_at <= ?', Time.now.beginning_of_month, Time.now.end_of_month)
                                        .group(:user_id)
                                        .order('user_count DESC')
                                        .limit(3)
    @mission_top_users = UserMission.select('user_id, COUNT(user_id) AS user_count')
                                    .where(completed: true)
                                    .group(:user_id)
                                    .order('user_count DESC')
                                    .limit(3)
    @monthly_mission_top_users = UserMission.select('user_id, COUNT(user_id) AS user_count')
                                            .where('completed = ? AND created_at >= ? AND created_at <= ?', true, Time.now.beginning_of_month, Time.now.end_of_month)
                                            .group(:user_id)
                                            .order('user_count DESC')
                                            .limit(3)
  end

  private

  def rally_params
    params.require(:rally).permit(:title, :abstract, :background, :idea, :method, :result,
                                  :discussion, :conclusion, :opinion, :draft, :url).merge(user_id: current_user.id)
  end

  def set_rally
    @rally = Rally.find(params[:id])
  end

  def move_to_index
    return unless current_user.id != @rally.user.id

    redirect_to action: :index
  end

  def rally_save(rally, update: false)
    if params[:save_as_draft]
      rally.draft = true
    elsif params[:publish]
      rally.draft = false
    end

    if update ? rally.update(rally_params) : rally.save
      update_user_missions(rally)
      redirect_to rally_lists_rallies_path
    else
      render (update ? :edit : :new), status: :unprocessable_entity
    end
  end

  def update_user_missions(rally)
    mission_ids = rally.draft ? [5] : [1, 5]
    mission_ids.each do |mission_id|
      mission = UserMission.find_by(user_id: current_user.id, mission_id:, completed: false)
      mission.update(completed: true) if mission
    end
  end
end
