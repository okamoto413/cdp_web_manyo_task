class Task < ApplicationRecord
  # バリデーションに失敗した場合、タイトルが未入力の場合	"Title can’t be blank"とバリデーションメッセージを表示させる。
  validates :title, presence:true
  # バリデーションに失敗した場合、内容が未入力の場合	"Content can’t be blank"とバリデーションメッセージを表示させる。
  validates :content, presence:true 
  #created_atの降順でタスク並べる
  default_scope { order(created_at: :desc) }
end
