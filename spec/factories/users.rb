FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(name: name) }
    password { Faker::Internet.password(min_length: 5) }
    phone { Faker::Base.numerify('019#######') }
  end
end
