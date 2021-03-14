FactoryBot.define do
  factory :user do
    nickname              {Faker::Name.name}
    email                 {Faker::Internet.email}
    password              {"1a" + Faker::Internet.password}
    password_confirmation {password}
    first_name            {"たかお"}
    last_name             {"けいた"}
    first_name_kana       {"タカオ"}
    last_name_kana        {"ケイタ"}
    birth_date            {Faker::Date.birthday(min_age: 18, max_age: 65)}
  end
end