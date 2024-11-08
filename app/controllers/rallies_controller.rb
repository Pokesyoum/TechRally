class RalliesController < ApplicationController
  before_action :set_rally, only: [:show, :edit]
  before_action :move_to_index, except: [:index, :show]
  before_action :authenticate_user!, only: [:index, :new, :edit, :destroy]
  before_action :set_user

  def index
    @rallies = Rally.where(draft: false).order(created_at: :desc)
  end

  def new
    @rally = Rally.new
  end

  def create
    if params[:save_as_draft]
      params[:rally][:draft] = true
    elsif params[:publish]
      params[:rally][:draft] = false
    end

    @rally = Rally.new(rally_params)

    if @rally.save
      mission = UserMission.find_by(user_id: current_user.id, mission_id: 1, completed: false)
      mission.update(completed: true) if mission
      redirect_to rally_lists_rallies_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comments = @rally.comments
    @comment = Comment.new
  end

  def edit
  end

  def update
    @rally = Rally.find(params[:id])

    if params[:save_as_draft]
      params[:rally][:draft] = true
    elsif params[:publish]
      params[:rally][:draft] = false
    end

    if @rally.update(rally_params)
      mission = UserMission.find_by(user_id: current_user.id, mission_id: 5, completed: false)
      mission.update(completed: true) if mission
      redirect_to rally_lists_rallies_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    rally = Rally.find(params[:id])
    rally.destroy
    redirect_to rally_lists_rallies_path
  end

  def rally_lists
    @rallies = @user.rallies
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
                                    .where(completed: 1)
                                    .group(:user_id)
                                    .order('user_count DESC')
                                    .limit(3)
    @monthly_mission_top_users = UserMission.select('user_id, COUNT(user_id) AS user_count')
                                            .where('completed = ? AND created_at >= ? AND created_at <= ?', 1, Time.now.beginning_of_month, Time.now.end_of_month)
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
    return if user_signed_in?

    redirect_to action: :index
  end

  def set_user
    @user = current_user
  end
end
