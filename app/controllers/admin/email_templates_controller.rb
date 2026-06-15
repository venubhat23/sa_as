module Admin
  class EmailTemplatesController < Admin::ApplicationController
    before_action :set_email_template, only: [:show, :edit, :update, :destroy]

    def index
      @email_templates = EmailTemplate.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @email_template = EmailTemplate.new
    end

    def create
      @email_template = EmailTemplate.new(email_template_params)
      if @email_template.save
        redirect_to admin_email_template_path(@email_template), notice: "Email Template created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @email_template.update(email_template_params)
        redirect_to admin_email_template_path(@email_template), notice: "Email Template updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @email_template.destroy
      redirect_to admin_email_templates_path, notice: "Email Template deleted successfully."
    end

    private

    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    def email_template_params
      params.require(:email_template).permit(:name, :subject, :body, :template_type, :status)
    end
  end
end
