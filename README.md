## 環境変数

### PAYJP

bash_profile もしくは zshrc へ追記してください。
記入後は`resources ~/.zshrc`or`resources ~/.bash_profile`で反映しましょう。
もしくは、ターミナルの再起動を行ってください。

```bash
export PAYJP_SK="登録しているPAYJPのSK"
export PAYJP_PK="登録しているPAYJPのPK"
```

### webpacker で環境変数を使用するには

`furima/config/initializers/webpacker.rb`を作成し下記のように記述します。

```ruby
Webpacker::Compiler.env["PAYJP_SK"] = ENV["PAYJP_SK"]
```

あとは js ファイルで下記のように使用するだけです。

```javascript
const PAYJP_SK = process.env.PAYJP_SK;
Payjp.setPublicKey(PAYJP_SK);
```

こちらの記事を参考にしています。
https://qiita.com/takeyuweb/items/61e6ba07fe0df3079041

## rubocop

設定は`.rubocop.yml`を参照。

### チェック

```bash
bundle ex rubocop
```

### チェック＋自動修正

```bash
bundle ex rubocop -a
```

## DB 設計

## users table

| Column             | Type                | Options                 |
|--------------------|---------------------|-------------------------|
| nickname           | string              | null: false,index: true |
| email              | string              | null: false             |
| encrypted_password | string              | null: false             |
| first_name         | string              | null: false             |
| last_name          | string              | null: false             |
| first_name_kana    | string              | null: false             |
| last_name_kana     | string              | null: false             |
| birth_date         | date                | null: false             |

### Association

* has_many :items
* has_many :item_transactions

## addresses table

| Column       | Type    | Options           |
|--------------|---------|-------------------|
| postal_code  | integer | null: false       |
| prefecture   | integer | null: false       |
| city         | string  | null: false       |
| address      | string  | null: false       |
| building     | string  |                   |
| phone_number | string  | null: false       |
| item_transaction_id(FK)  | integer | foreign_key: true |

### Association

* belongs_to :item_transaction

## items table

| Column                              | Type       | Options           |
|-------------------------------------|------------|-------------------|
| id(PK)                              | デフォルト   | null: false       |
| name                                | string     | null: false       |
| price                               | integer    | null: false       |
| info                                | text       | null: false       |
| scheduled_delivery_id(acitve_hash)  | integer    | null: false       |
| shipping_fee_status_id(acitve_hash) | integer    | null: false       |
| prefecture_id(acitve_hash)          | integer    | null: false       |
| sales_status_id(acitve_hash)        | integer    | null: false       |
| category_id(acitve_hash)            | integer    | null: false       |
| user_id(FK)                         | integer    | foreign_key: true |

### Association

- belongs_to :user
- has_one :item_transaction

## item_transactions table

| Column      | Type    | Options           |
|-------------|---------|-------------------|
| item_id(FK) | integer | foreign_key: true |
| user_id(FK) | integer | foreign_key: true |

### Association

- belongs_to :item
- belongs_to :user
- has_one :address

## 備考

### 背景色が production で動作しない問題の対処

実際に起きて作業したので、作業ログとして記載させてください。

#### 準備

[1]`background-image: image-url('bg-main-visual-pict_pc.jpg');`のように`image-url`を使用する。

[2]`background-image: image-url('bg-main-visual-pict_pc.jpg');`などの`image-url`を使用しているファイルの拡張子を css から scss に変更。

### heroku の環境変数設定

参考：https://devcenter.heroku.com/articles/config-vars

**一覧表示**
`% heroku config`

**特定の変数を表示**
`% heroku config:get <変数名>`

**変数をセットする**
`% heroku config:set <変数名>=<値>`

**変数を削除する**
`% heroku config:unset <変数名>`

**Railsで使用するは変わらず下記で可能**
`ENV['<変数名>']`
