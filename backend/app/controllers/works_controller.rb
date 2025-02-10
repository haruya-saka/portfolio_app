class WorksController < ApplicationController
  before_action :set_user
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  def index
    @works = @user.works
    respond_to do |format|
      format.html
      format.json { render json: @works }
    end
  end

  def show
  end

  def new
    @work = @user.works.build
  end

  def create
    @work = @user.works.build(work_params)
    if @work.save
      respond_to do |format|
        format.html { redirect_to user_works_path(@user), notice: 'Work was successfully created.' }
        format.json { render json: { redirect_url: user_works_path(@user) }, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @work.update(work_params)
      redirect_to user_work_path(@user, @work), notice: 'Work was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @work.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_work
    @work = @user.works.find(params[:id])
  end

  def work_params
    params.require(:work).permit(:title, :description, :image)
  end
end