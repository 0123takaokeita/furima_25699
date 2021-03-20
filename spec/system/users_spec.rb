require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context "新規登録ができるとき" do
    it "保存したあとはトップに戻ってくる" do
      # トップページ遷移
      visit root_path
      # 新規登録ボタンがある
      expect(page).to have_content("新規登録")  
      # 新規登録ページに遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in "nickname",	with: "TKO"
      fill_in "email",	with: "aa@aa"
      fill_in "password",	with: "qqq111"
      fill_in "password-confirmation",	with: "qqq111"
      fill_in "first-name",	with: "たかお"
      fill_in "last-name",	with: "けいた"
      fill_in "first-name-kana",	with: "タカオ"
      fill_in "last-name-kana",	with: "ケイタ"
      # プルダウンのときはnameかidで選択して入力する。
      # select '1930', from: 'user[birth_date(1i)]'
      select '1930', from: 'user_birth_date_1i'
      select '1', from: 'user_birth_date_2i'
      select '1', from: 'user_birth_date_3i'
      # 配送先情報入力ページに移動する。
      click_button "会員登録"
      expect(page).to have_content("配送先情報入力")
      # 情報の入力 
      fill_in "address_preset_postal_code", with: "111-1111"
      select '北海道', from: 'address_preset_prefecture'
      fill_in "address_preset_city", with: "奈良"
      fill_in "address_preset_addresses", with: "奈良"
      fill_in "building", with: "東大寺"
      fill_in "phone-number", with: "00099998888"
      # 登録ボタンを押すとモデルのカウントが1上がる
      expect{click_button "会員登録"}.to change {User.count}.by(1)
      # 完了ページに遷移する
      expect(current_path).to eq(users_create_address_preset_path)
      # 開始ボタンを押すとトップページに遷移する。
      click_on "FURIMAの利用を始める"
      expect(current_path).to eq(root_path)
      # ログアウトボタンがある
      expect(page).to have_content("ログアウト")  
      # 新規登録ボタンが消えている
      expect(page).to have_no_content("新規登録")  
    end
  end
  context "保存できない時" do
    it "USER入力に失敗しtた時" do
      # トップページ遷移
      visit root_path
      # 新規登録ボタンがある
      expect(page).to have_content("新規登録")  
      # 新規登録ページに遷移する
      click_on "新規登録"
      # ユーザー情報を空で入力する
      fill_in "nickname", with: ""
      fill_in "email", with: ""
      fill_in "password", with: ""
      fill_in "password-confirmation", with: ""
      fill_in "first-name", with: ""
      fill_in "last-name", with: ""
      fill_in "first-name-kana", with: ""
      fill_in "last-name-kana", with: ""
      # select '1930', from: 'user[birth_date(1i)]'
      select "1930", from: 'user_birth_date_1i'
      select "1", from: 'user_birth_date_2i'
      select "1", from: 'user_birth_date_3i'
      # 登録に失敗してもう一度入力を促される。
      click_on "会員登録"
      expect(page).to have_content("会員情報入力")  
      expect(current_path).to eq(user_registration_path)
    end
    it '配送先入力で失敗すると配送先ページに遷移する。' do 
      # トップページ遷移
      visit root_path
      # 新規登録ボタンがある
      expect(page).to have_content("新規登録")  
      # 新規登録ページに遷移する
      click_on "新規登録"
      # ユーザー情報を入力する
      fill_in "nickname",	with: "TKO"
      fill_in "email",	with: "aa@aa"
      fill_in "password",	with: "qqq111"
      fill_in "password-confirmation",	with: "qqq111"
      fill_in "first-name",	with: "たかお"
      fill_in "last-name",	with: "けいた"
      fill_in "first-name-kana",	with: "タカオ"
      fill_in "last-name-kana",	with: "ケイタ"
      # プルダウンのときはnameかidで選択して入力する。
      # select '1930', from: 'user[birth_date(1i)]'
      select '1930', from: 'user_birth_date_1i'
      select '1', from: 'user_birth_date_2i'
      select '1', from: 'user_birth_date_3i'
      # 配送先情報入力ページに移動する。
      click_button "会員登録"
      expect(current_path).to eq(user_registration_path)
      fill_in "address_preset_postal_code", with: ""
      # fill_in "address_preset_prefecture", with: "111-1111"
      select "奈良県", from: "address_preset_prefecture"
      fill_in "address_preset_city", with: ""
      fill_in "address_preset_addresses", with: ""
      fill_in "building", with: ""
      fill_in "phone-number", with: ""
      # 登録ボタンを押すとモデルのカウントは上がらない
      expect{click_button "会員登録"}.to change {User.count}.by(0)
      # 配送先入力ページに遷移する
      expect(current_path).to eq(users_create_address_preset_path)
      
      expect(page).to have_content("配送先情報入力")  
    end  
  end
end
