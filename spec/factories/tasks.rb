# 「FactoryBotを使用します」という記述
FactoryBot.define do


  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :task do
    title { 'new_task' }
    content { 'タスク内容' }
    created_at { Time.zone.now }
    deadline_on { '2025-02-10' }
    priority { 2 }
    status { 0 }
    association :user
  end

  factory :first_task, class: Task do
    title { 'タイトル' }
    content { 'タスク内容' }
    deadline_on { '2022-02-18' }
    priority { 1 }
    status { 0 }
    association :user
  end

  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'タイトル' }
    content { 'タスク内容' }
    deadline_on { '2022-02-17' }
    priority { 1 }
    status { 1 }
    association :user
  end

  factory :third_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { '2022-02-16' }
    priority { 0 }
    status { 2 }
    association :user
  end
end