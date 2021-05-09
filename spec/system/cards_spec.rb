require 'rails_helper'

RSpec.describe "Cards", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context "新規登録ができるとき" do
    it "保存したあとはトップに戻ってくる" do
    # トップページに遷移する
    visit root_path
    # ログインボタンをクリックする
    click_on 'ログイン'
    # ログインフォームにEmailとパスワードを入力する
    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password
    # ログインする。
    click_on 'ログイン'
    # 自分の名前のリンクが有る
    expect(page).to have_content(@user.nickname)
    # 自分の名前のリンクをクリックする
    click_on @user.nickname
    # 登録画面に遷移する
    expect(current_path).to eq(cards_path)
    # 登録をクリック
    click_on "クレジットカードを登録する"
    # フォームに入力する。
    fill_in "card-number", with: "4242424242424242"
    fill_in "card-exp-month", with: "11"
    fill_in "card-exp-year", with: "44"
    fill_in "card-cvc", with: "123"
    # 購入をクリック。
    click_on "登録"
    allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.prepare_valid_charge)
    binding.pry
    # 完了のポップアップが出る
    page.driver.browser.switch_to.alert.accept
    # モデルのカウントが１上がる
    # 削除のボタンが有る
    # 削除を押す。
    # 削除ボタンがなくなる
      end
    end
    
    # できない時
    # トップページに遷移する
    # 自分の名前のリンクが有る
    # 自分の名前のリンクをクリックする
    # 登録画面に遷移する
    # 登録をクリック
    # フォームを空にする。
    # 購入をクリック。
    # 失敗のポップアップが出る
    # モデルのカウントが変わらない。
  end
