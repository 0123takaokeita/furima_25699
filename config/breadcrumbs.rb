rumb :root do
  link "トップページ", root_path
end

crumb :new_item do
  link "新規出品画面", new_item_path
  parent :root
end

# 以下追加
crumb :show_item do |item|
  link "商品名: #{item.name}" , item_path(item)
  parent :root
end