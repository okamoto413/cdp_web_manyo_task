FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end

    factory :admin_user, class: User do
    email { 'admin@example.com' }
    password { 'password' }
    admin { true }
  end
end