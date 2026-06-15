module Admin
  class OneToOnesController < Admin::ApplicationController
    before_action :set_one_to_one, only: [:show, :edit, :update, :destroy]

    def index
      @one_to_ones = OneToOne.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @one_to_one = OneToOne.new
    end

    def create
      @one_to_one = OneToOne.new(one_to_one_params)
      if @one_to_one.save
        redirect_to admin_one_to_one_path(@one_to_one), notice: "One To One created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @one_to_one.update(one_to_one_params)
        redirect_to admin_one_to_one_path(@one_to_one), notice: "One To One updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @one_to_one.destroy
      redirect_to admin_one_to_ones_path, notice: "One To One deleted successfully."
    end

    private

    def set_one_to_one
      @one_to_one = OneToOne.find(params[:id])
    end

    def one_to_one_params
      params.require(:one_to_one).permit(:member1_id, :member2_id, :meeting_date, :location, :agenda, :discussion_notes, :action_items, :status)
    end
  end
end
