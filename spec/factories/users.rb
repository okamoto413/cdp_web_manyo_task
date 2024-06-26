FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end

    factory :admin_user, class: User do
    name { Faker::Name.name }
    email { 'admin@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { true }
  end
end