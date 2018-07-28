class TasksController < ApplicationController
  def index
    render json: Task.all
  end

  def create
    @task = Task.create(task_params)
    render json: @task
  end

  def show
    @task = Task.find(params[:id])
    render json: @task
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)
    render json: @task # return object after update
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :name)
  end
end
