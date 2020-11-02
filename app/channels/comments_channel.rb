class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "comments_channel"   #追加
    @item = Item.find(params[:item_id]) # 変更
    stream_for @item      
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end