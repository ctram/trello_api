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
    begin
      ActiveRecord::Base.transaction do
        column.update!(column_params)
        column.update_sibling_positions if column.position_previously_changed?
      end
    rescue ActiveRecord::RecordInvalid => e
      return render(status: 422, json: { error: e })
    end
    render json: column
  end

  def destroy
    column = Column.find(params[:id])
    column.destroy
  end

  private

  def column_params
    params.require(:column).permit(:title, :name, :position)
  end
end
