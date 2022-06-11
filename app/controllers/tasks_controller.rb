# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    status = params[:status] if params[:status].present?

    @tasks = current_user.tasks.search(params[:search]).filter_by_status(status).ordered
  end

  def show; end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: t(:create_task) }
        format.turbo_stream { flash.now[:notice] = t(:create_task) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: t(:update_task) }
        format.turbo_stream { flash.now[:notice] = t(:update_task) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: t(:destroy_task) }
      format.turbo_stream { flash.now[:notice] = t(:destroy_task) }
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :status)
  end
end
