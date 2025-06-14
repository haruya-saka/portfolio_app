class WorksController < ApplicationController
  before_action :set_user
  before_action :set_work, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @works = @user.works.includes(:work_images, :favorites)
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
            orientation: first_image&.orientation,
            favorite_count: work.favorite_count
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
      if params[:work][:work_images].present?
        params[:work][:work_images].each do |uploaded_file|
          blob = ActiveStorage::Blob.create_and_upload!(
            io: uploaded_file.tempfile,
            filename: uploaded_file.original_filename,
            content_type: uploaded_file.content_type
          )
          image_url = Rails.application.routes.url_helpers.rails_blob_url(blob, only_path: true)
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
      if params[:work][:images].present?
        @work.work_images.destroy_all
        params[:work][:images].each do |image|
          image_url = Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
          @work.work_images.create(image_url: image_url, orientation: 'landscape')
        end
      end
      respond_to do |format|
        format.html { redirect_to user_work_path(@user, @work), notice: 'Work was successfully updated.' }
        format.json { render json: { redirect_url: user_work_path(@user, @work) }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @work.destroy
    respond_to do |format|
      format.html { redirect_to user_works_path(@user), notice: 'Work was successfully deleted.' }
      format.json { render json: { redirect_url: user_works_path(@user) }, status: :ok }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_work
    @work = @user.works.find(params[:id])
  end

  def authorize_user
    unless current_user && current_user.id == @user.id
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def work_params
    params.require(:work).permit(:title, :description, images: [])
  end
end