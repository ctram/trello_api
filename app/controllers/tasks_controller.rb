class TasksController < ApplicationController
  def index
    render json: Task.all
  end

  def create
    task = Task.new(column_id: params[:column_id])
    task.update(task_params)
    render json: task, status: 201
  end

  def show
    task = Task.find(params[:id])
    render json: task
  end
  
  def update
    task = Task.find(params[:id])
    begin
      ActiveRecord::Base.transaction do
        task.update!(task_params)
        task.update_sibling_positions if task.position_previously_changed?
      end
    rescue ActiveRecord::RecordInvalid => e
      return render(status: 422, json: { error: e })
    end
    render json: task
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :name)
  end
end
