class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    # バリデーションで問題があれば、保存はされず「商品出品画面」を再描画
    if @item.valid?
      @item.save
      return redirect_to root_path
    end
    # アクションのnewをコールすると、エラーメッセージが入った@itemが上書きされてしまうので注意
    render 'new'
  end
  
end
