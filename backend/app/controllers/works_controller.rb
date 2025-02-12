class WorksController < ApplicationController
  before_action :set_user
  before_action :set_work, only: [:edit, :update, :destroy]

  def index
    @works = @user.works.includes(:work_images)
    respond_to do |format|
      format.html { render :index } 
      format.json do
        render json: @works.map { |work|
          first_image = work.work_images.first
          {
            id: work.id,
            title: work.title,
            description: work.description,
            thumbnail_url: first_image&.image_url,
            orientation: first_image&.orientation
          }
        }
      end
    end
  end

  def show
    @work = @user.works.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb を表示
      format.json do
        render json: {
          id: @work.id,
          title: @work.title,
          description: @work.description,
          images: @work.work_images.map { |img|
            { image_url: img.image_url, orientation: img.orientation }
          }
        }
      end
    end
  end

  def new
    @work = @user.works.build
  end

  def create
    @work = @user.works.build(work_params)
    if @work.save
      if @work.images.attached?
        # 複数画像に対応し、添付済みの画像を1枚ずつ WorkImage に登録
        @work.images.each do |attached_image|
          image_url = Rails.application.routes.url_helpers.rails_blob_url(attached_image, only_path: true)
          @work.work_images.create(image_url: image_url, orientation: 'landscape')
        end
      end
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
    params.require(:work).permit(:title, :description, images: [])
  end
end