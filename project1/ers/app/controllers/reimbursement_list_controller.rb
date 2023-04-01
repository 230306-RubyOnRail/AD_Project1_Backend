class ReimbursementListController < ApplicationController
  include Authenticatable
  def index # GET /users/:user_id/lists
    @reimbursement_lists = ReimbursementList.includes(:reimbursements).where(user_id: current_user.id)
    render json: { reimbursement_lists: @reimbursement_lists }, status: :ok
  end

  def create # POST /users/:user_id/lists
    data = JSON.parse(request.body.read)
    data[:user_id] = current_user.id
    @reimbursement_list = ReimbursementList.new(data)
    if @reimbursement_list.save
      render json: { reimbursement_list: @reimbursement_list }, status: :created
    else
      render json: @reimbursement_list.errors, status: :unprocessable_entity
    end
  end

  def show # GET /users/:user_id/lists/:id
    @reimbursement_list = ReimbursementList.includes(:reimbursements).where(id: params[:id], user_id: current_user.id).first
    if @reimbursement_list
      render json: { reimbursement_list: @reimbursement_list }, status: :ok
    else
      head :not_found
    end
  end

  def update # PUT/PATCH reimbursement_lists/:id
    @reimbursement_list = ReimbursementList.where(id: params[:id], user_id: current_user.id).first
    if @reimbursement_list
      if @reimbursement_list.update(JSON.parse(request.body.read))
        head :no_content
      else
        render json: @reimbursement_list.errors, status: :unprocessable_entity
      end
    else
      head :not_found
    end
  end

  def delete # DELETE /users/:user_id/lists/:id
    @reimbursement_list = ReimbursementList.where(id: params[:id], user_id: current_user.id).first
    @reimbursement_list.destroy if @reimbursement_list
    head :no_content
  end
end
