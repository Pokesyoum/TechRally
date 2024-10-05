class RalliesController < ApplicationController
  def index
    @rallies = Rally.all
  end

  def new
    @rally = Rally.new
  end

  def create
    @rally = Rally.new(rally_params)
    if @rally.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @rally = Rally.find(params[:id])
  end

  def edit
    @rally = Rally.find(params[:id])
  end

  def update
    rally = Rally.find(params[:id])
    if rally.update(rally_params)
      redirect_to rally_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def rally_params
    params.require(:rally).permit(:title, :abstract, :background, :idea, :method, :result,
                                  :discussion, :conclusion, :opinion).merge(user_id: current_user.id)
  end
end
