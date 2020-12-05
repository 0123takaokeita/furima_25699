FactoryBot.define do
  factory :user do
    nickname              {"test"}
    email                 {"test2@example"}
    password              {"0000aaaa"}
    password_confirmation {password}
    
  end
end