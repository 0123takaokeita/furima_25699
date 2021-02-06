FactoryBot.define do
  factory :user do
    nickname              {"test"}
    email                 {"test2@example"}
    password              {"1a" + Faker::Internet.password}
    password_confirmation {password}
    first_name            {"たかお"}
    last_name             {"けいた"}
    first_name_kana       {"タカオ"}
    last_name_kana        {"ケイタ"}
    birth_date            {"2020/01/01"}
  end
end