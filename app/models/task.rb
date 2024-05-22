class Task < ApplicationRecord
  # バリデーションに失敗した場合、タイトルが未入力の場合	"Title can’t be blank"とバリデーションメッセージを表示させる。
  validates :title, presence:true
  # バリデーションに失敗した場合、内容が未入力の場合	"Content can’t be blank"とバリデーションメッセージを表示させる。
  validates :content, presence:true 
#deadline_onカラム、priorityカラム、statusカラムを追加
  validates :deadline_on, presence:true 
  validates :priority, presence:true 
  validates :status, presence:true   

  #created_atの降順でタスク並べる
  #default_scope { order(created_at: :desc) }
  #優先度「低」に0、「中」に1、「高」に2を対応させる
  enum priority: {low:0, medium:1, high:2}
  #ステータス「未着手」に0、「着手中」に1、「完了」に2を対応させる
  enum status: {not_started:0, started:1, completed:2}
end
