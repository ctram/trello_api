class BoardsController < ApplicationController
  def create
    Board.create(board_params)
  end

  def show
    @board = Board.find(params[:id])
    render json: @board
  end

  private

  def board_params
    params.require(:board).permit(:title, :name)
  end
end
