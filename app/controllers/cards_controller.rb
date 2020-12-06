class CardsController < ApplicationController


  before_action :authenticate_user!, only: [:index, :new, :create, :destroy]
  before_action :current_user_has_card, only: [:new, :create]

  
  def index
    ## カードが登録されていないならここで終了
    return unless current_user.card.present?

    Payjp.api_key = ENV["PAYJP_SK"] # 環境変数を読み込む
    customer = Payjp::Customer.retrieve(current_user.card.customer_token) # 先程のカード情報を元に、顧客情報を取得
    @card = customer.cards.first
  end

  def new
  end

  def create

    Payjp.api_key = ENV["PAYJP_SK"] # 環境変数を読み込む

    customer = Payjp::Customer.create(
    description: 'test', # テストカードであることを説明
    card: params[:token] # 登録しようとしているカード情報
    )

    card = Card.new( # トークン化されたカード情報を保存する
      card_token: customer.default_card, # カードトークン
      customer_token: customer.id, # 顧客トークン
      user_id: current_user.id # ログインしているユーザー
    )

    if card.save
      redirect_to cards_path
    else
      redirect_to new_card_path
    end

  end

  def destroy
    if current_user.card.destroy
      redirect_to cards_path, notice: "クレジットカードの削除が完了しました"
    else
      redirect_to cards_path, alert: "クレジットカードの削除に失敗しました"
    end
  end

  private

  def current_user_has_card
    redirect_to cards_path, alert: "既にクレジットカードを登録済みです" if current_user.card
  end

end
