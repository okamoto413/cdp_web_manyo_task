# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#seedデータを使って、50件分のタスクデータを投入できるようにする
# 10.times do |i|
#   Task.create!(
#     title: "Task#{i+1}",
#     content: "任意",
#     deadline_on: "2022-02-#{18-(i%10)}",
#     priority: rand(0..2),  # 低, 中, 高のいずれかをランダムに設定
#     status: rand(0..2) # 未着手, 着手中, 完了のいずれかをランダムに設定
#   )

#  一般ユーザのデータを1件ずつ投入できるようにすること
user = User.create!(
  name: "General User",
  email: "user@example.com",
  password: "password"
)

#  管理者のデータを1件ずつ投入できるようにすること
admin = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  admin: true
)


# 一般ユーザと管理者に関連付けられたタスクがそれぞれ50件ずつ投入できるようにすること
# admin = User.find_by(email: "user@example.com")
50.times do |i|
  Task.create!(
    user: user,
    title: "Task#{i+1}",
    content: "任意",
    deadline_on: Date.today + (i % 10).days,
    priority: rand(0..2),  # 低, 中, 高のいずれかをランダムに設定
    status: rand(0..2)
  )
end

# admin = User.find_by(email: "admin@example.com")
50.times do |i|
  Task.create!(
    user: admin,
    title: "Admin Task#{i+1}",
    content: "任意",
    deadline_on: Date.today + (i % 10).days,
    priority: rand(0..2),  # 低, 中, 高のいずれかをランダムに設定
    status: rand(0..2)
  )
end