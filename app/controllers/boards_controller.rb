class BoardsController < ApplicationController
  def index
    render json: Board.all
  end

  def create
    @board = Board.create(board_params)
    render json: @board
  end

  def show
    @board = Board.find(params[:id])
    render json: @board
  end

  def update
    @board = Board.find(params[:id])
    @board.update!(board_params)
    render json: @board # return object after update
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
  end

  private

  def board_params
    params.require(:board).permit(:title, :name)
  end
end
