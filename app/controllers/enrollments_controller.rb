class EnrollmentsController < ApplicationController
  before_action :set_params

  def enroll
    authorize! :enroll_in, @course

    if @course.enrollment_key.blank? || enrollment_params[:enrollment_key] == @course.enrollment_key
      Enrollment.create!(user: current_user, course: @course)
      redirect_to organization_course_path(@organization, @course), notice: "Successfully enrolled to #{@course.title}"
    else
      redirect_to organization_course_path(@organization, @course), alert: 'Invalid course key'
    end
  end

  private

  def set_params
    @organization = Organization.find_by!(slug: params[:organization_id])
    @course = Course.find_by!(id: params[:id], organization: @organization)
    #@course = Course.find_by!(name: params[:name], organization: @organization) # After PR #318 merge
  end

  def enrollment_params
    params.permit(:enrollment_key)
  end
end