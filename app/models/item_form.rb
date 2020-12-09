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

end