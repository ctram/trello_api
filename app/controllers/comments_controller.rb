class CommentsController < ApplicationController
  def index
    render json: Comment.all
  end

  def create
    @comment = Comment.create(comment_params)
    render json: @comment, status: 201
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update!(comment_params)
    render json: @comment # return object after update
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
