crumb :root do
  link "トップページ", root_path
end

crumb :new_item do
  link "新規出品画面", new_item_path
  parent :root
end

# crumb :show_item do |item|
#   link "商品名: #{item.name}" , item_path(item)
#   parent :root
# end


crumb :show_item do |item|
  if item.item_transaction
    link "商品名: #{item.name}(売り切れ)", item_path(item)
  else
    link "商品名: #{item.name}", item_path(item)
  end
  parent :root
end


crumb :edit_item do |item|
  link "商品編集画面"
  parent :show_item, item
end

crumb :transaction do |item|
  link "商品購入画面"
  parent :show_item, item
end

crumb :purchase_with_card do |item|
  link "商品購入画面(登録カードで決済)"
  parent :show_item, item
end

crumb :index_card do
  link "カード確認画面", cards_path
  parent :root
end

crumb :new_card do
  link "カード登録画面"
  parent :index_card
end