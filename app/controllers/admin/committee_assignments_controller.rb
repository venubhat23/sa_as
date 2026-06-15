module Admin
  class CommitteeAssignmentsController < Admin::ApplicationController
    before_action :set_committee_assignment, only: [:show, :edit, :update, :destroy]

    def index
      @committee_assignments = CommitteeAssignment.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @committee_assignment = CommitteeAssignment.new
    end

    def create
      @committee_assignment = CommitteeAssignment.new(committee_assignment_params)
      if @committee_assignment.save
        redirect_to admin_committee_assignment_path(@committee_assignment), notice: "Committee Assignment created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @committee_assignment.update(committee_assignment_params)
        redirect_to admin_committee_assignment_path(@committee_assignment), notice: "Committee Assignment updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @committee_assignment.destroy
      redirect_to admin_committee_assignments_path, notice: "Committee Assignment deleted successfully."
    end

    private

    def set_committee_assignment
      @committee_assignment = CommitteeAssignment.find(params[:id])
    end

    def committee_assignment_params
      params.require(:committee_assignment).permit(:member_id, :committee_role_id, :chapter_id, :start_date, :end_date, :status)
    end
  end
end
