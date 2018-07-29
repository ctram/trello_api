class ColumnsController < ApplicationController
  def index
    render json: Column.all
  end

  def create
    column = Column.new(board_id: params[:board_id])
    column.update!(column_params)
    render json: column, status: 201
  end

  def show
    column = Column.find(params[:id])
    render json: column
  end

  def update
    column = Column.find(params[:id])
    result = ActiveRecord::Base.transaction do
      column.update!(cloned_column_params)
      if column.position_previously_changed?
        return update_sibling_positions(column.position)
      end
    end
    if result
      return render json: column # return object after update
    end
    render status: 400
  end

  def destroy
    column = Column.find(params[:id])
    column.destroy
  end

  def update_sibling_positions(position)
    column.update_sibling_positions(position)
  end

  private

  def column_params
    params.require(:column).permit(:title, :name, :position)
  end
end
