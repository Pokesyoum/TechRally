class RalliesController < ApplicationController
  before_action :set_rally, only: [:show, :edit]
  before_action :move_to_index, except: [:index, :show]
  before_action :authenticate_user!, only: [:index, :new, :edit, :destroy]
  before_action :set_user

  def index
    @rallies = Rally.all
  end

  def rally_lists
    @rallies = @user.rallies
  end

  def new
    @rally = Rally.new
  end

  def create
    @rally = Rally.new(rally_params)
    if @rally.save
      mission = UserMission.find_by(user_id: current_user.id, mission_id: 1, completed: false)
      mission.update(completed: true) if mission
      redirect_to root_path
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
    rally = Rally.find(params[:id])

    if params[:save_as_draft]
      params[:rally][:draft] = 1
    elsif params[:publish]
      params[:rally][:draft] = 0
    end

    if rally.update(rally_params)
      redirect_to rally_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    rally = Rally.find(params[:id])
    rally.destroy
    redirect_to root_path
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
