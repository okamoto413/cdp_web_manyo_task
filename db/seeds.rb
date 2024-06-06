# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#seedデータを使って、50件分のタスクデータを投入できるようにする
10.times do |i|
  Task.create!(
    title: "Task#{i+1}",
    content: "任意",
    deadline_on: "2022-02-#{18-(i%10)}",
    priority: rand(0..2),  # 低, 中, 高のいずれかをランダムに設定
    status: rand(0..2) # 未着手, 着手中, 完了のいずれかをランダムに設定
  )
end