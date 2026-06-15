module Admin
  class ChaptersController < Admin::ApplicationController
    before_action :set_chapter, only: [:show, :edit, :update, :destroy]

    def index
      @chapters = Chapter.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @chapter = Chapter.new
    end

    def create
      @chapter = Chapter.new(chapter_params)
      if @chapter.save
        redirect_to admin_chapter_path(@chapter), notice: "Chapter created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @chapter.update(chapter_params)
        redirect_to admin_chapter_path(@chapter), notice: "Chapter updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @chapter.destroy
      redirect_to admin_chapters_path, notice: "Chapter deleted successfully."
    end

    private

    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    def chapter_params
      params.require(:chapter).permit(:name, :code, :forum_id, :description, :status)
    end
  end
end
