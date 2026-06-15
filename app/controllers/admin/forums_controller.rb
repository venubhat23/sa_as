module Admin
  class ForumsController < Admin::ApplicationController
    before_action :set_forum, only: [:show, :edit, :update, :destroy]

    def index
      @forums = Forum.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @forum = Forum.new
    end

    def create
      @forum = Forum.new(forum_params)
      if @forum.save
        redirect_to admin_forum_path(@forum), notice: "Forum created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @forum.update(forum_params)
        redirect_to admin_forum_path(@forum), notice: "Forum updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @forum.destroy
      redirect_to admin_forums_path, notice: "Forum deleted successfully."
    end

    private

    def set_forum
      @forum = Forum.find(params[:id])
    end

    def forum_params
      params.require(:forum).permit(:name, :description, :code, :status)
    end
  end
end
