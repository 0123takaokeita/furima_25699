
test_user_1 = FactoryBot.create(:user, nickname: "太郎")
test_user_2 = FactoryBot.create(:user, nickname: "次郎", email: "sample@com")
test_user_2 = FactoryBot.create(:user, password: "aaa111", email: "a@a")


item_1 = Item.where(
  name: "家電 新品 着払い 1~2日で発送 hoge太郎",
  info: "iphoneとかの会社",
  category_id: 7,
  sales_status_id: 1,
  shipping_fee_status_id: 1,
  prefecture_id: 1,
  scheduled_delivery_id: 1,
  price: 3000,
  user_id: test_user_1.id
).first_or_create

item_1.images.attach(io: File.open("./app/assets/images/apple-store.jpeg"), filename: 'apple.jpeg')
item_1.save!

item_2 = Item.where(
  name: "メンズ 未使用に近い 2~3日で発送 fuga次郎",
  info: "ピコーン",
  category_id: 2,
  sales_status_id: 2,
  shipping_fee_status_id: 1,
  prefecture_id: 1,
  scheduled_delivery_id: 2,
  price: 1000,
  user_id: test_user_2.id
).first_or_create

item_2.images.attach(io: File.open("./app/assets/images/icon-01.png"), filename: 'man.png')
item_2.save!

item_3 = Item.where(
  name: "メンズ 傷や汚れあり 4~7日で発送 hoge太郎",
  info: "Tシャツ",
  category_id: 2,
  sales_status_id: 5,
  shipping_fee_status_id: 1,
  prefecture_id: 1,
  scheduled_delivery_id: 3,
  price: 2000,
  user_id: test_user_1.id
).first_or_create

item_3.images.attach(io: File.open("./app/assets/images/m48043690132_1.jpg"), filename: 't-shirt.jpg')
item_3.save!