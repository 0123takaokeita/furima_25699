class ItemForm
  include ActiveModel::Model
  ## ItemFormクラスのオブジェクトがitemモデルの属性を扱えるようにする
  include ActiveModel::Attributes
  attribute :name,  :string
  attribute :info,  :string
  attribute :category_id, :big_integer
  attribute :sales_status_id, :big_integer
  attribute :shipping_fee_status_id, :big_integer
  attribute :prefecture_id, :big_integer
  attribute :scheduled_delivery_id, :big_integer
  attribute :price, :integer
  attribute :images, :binary
  attribute :user_id, :big_integer

  attribute :tag_name, :string  ## itemのnameと重複するためtagのnameはtag_nameとして扱う
  # <<バリデーション（ほぼitem.rbの流用）>>
  attribute :id, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  # 値が入っているか検証
  with_options presence: true do
    validates :images
    validates :name
    validates :info
    validates :price

  end

  # 金額が半角であるか検証
  validates :price, numericality: { message: 'Half-width number' }

  # 金額の範囲
  validates_inclusion_of :price, in: 300..9_999_999, message: 'Out of setting range'

  

  def save
    item = Item.new(
      name: name,
      info: info,
      price: price,
      category_id: category_id,
      sales_status_id: sales_status_id,
      shipping_fee_status_id: shipping_fee_status_id,
      prefecture_id: prefecture_id,
      scheduled_delivery_id: scheduled_delivery_id,
      user_id: user_id,
      images: images)

      if self.tag_name.present?
        ## 同じタグが作成されることを防ぐため、first_or_initializeで既に存在しているかチェックする
        tag = Tag.where(name: self.tag_name).first_or_initialize
        item.tags << tag
      end
    
    
      item.save
    
  end

  def update(params, item)
    ## paramsからtag_nameを除外し、除外したものを変数tag_nameに入れる
    ## ※ハッシュ.delete(:キー)で、ハッシュの中から渡したキーとそのバリューが削除され、バリューが返される
    ## 結果的にparamsから:tag_nameのキーとバリューが削除され、tag_nameに削除されたバリューが入る
    tag_name = params.delete(:tag_name)
    ## tag_nameが空ではない場合はタグを作る。first_or_initializeで重複がないかを確認しておく。
    ## ※先にtagを定義しておかないとrescue内でtagが使えない
    tag = Tag.where(name: tag_name).first_or_initialize if tag_name.present?
    ActiveRecord::Base.transaction do
      tag.save if tag_name.present?
      ## updateに!をつけると失敗したらrescueへ
      item.update!(params)
      ## itemから一旦タグを外す。
      item.item_tag_relations.destroy_all
      ## tag_nameがある場合はタグを付け直す。tag_nameがない場合はタグが0個になる
      ## ※タグがバリデーションに引っかかるとここでrescueへ行く
      item.tags << tag if tag_name.present?
      ## 成功であることを呼び出し元であるコントローラに伝えて終了
      return true
    end
    rescue => e
      ## なんらかのバリデーションに引っかかったとき、フォームオブジェクトへエラーメッセージを足していく

      ## itemのnameとtagのnameでエラーメッセージのキーが重複するため、tagはtag_nameとしておく
      tag.errors.messages[:tag_name] = tag.errors.messages.delete(:name) if tag&.errors&.messages&.present?
      ## itemのエラーメッセージをitem_formオブジェクトのエラーメッセージに追加していく
      item&.errors&.messages&.each do |key, message|
        self.errors.add(key, message.first)
      end
      ## tagのエラーメッセージをitem_formオブジェクトのエラーメッセージに追加していく
      tag&.errors&.messages&.each do |key, message|
        self.errors.add(key, message.first)
      end
      ## 失敗したことを呼び出し元であるコントローラに伝えて終了
      return false
  end

end