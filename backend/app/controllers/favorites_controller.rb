class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @work = Work.find(params[:work_id])
    @favorite = current_user.favorites.build(work: @work)

    if @favorite.save
      render json: { success: true }
    else
      render json: { success: false, errors: @favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @work = Work.find(params[:work_id])
    @favorite = current_user.favorites.find_by(work: @work)

    if @favorite&.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: @favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
