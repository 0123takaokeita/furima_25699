class CommentsController < ApplicationController
  def create
    # 追加
    @item = Item.find(params[:item_id]) 
    @comment = Comment.new(comments_params)
    if @comment.save
      # 変更
      CommentsChannel.broadcast_to @item, { comment: @comment, user: @comment.user }  
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:content)
      .merge(user_id: current_user.id, item_id: params[:item_id])
  end
end