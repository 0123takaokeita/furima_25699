class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comments_params)
    if @comment.save
                                    # 部屋の名前
      ActionCable.server.broadcast "comments_channel", {comment: @comment, user: @comment.user}
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:content)
      .merge(user_id: current_user.id, item_id: params[:item_id])
  end
end