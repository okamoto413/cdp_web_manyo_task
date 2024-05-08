class Task < ApplicationRecord
  # バリデーションに失敗した場合、タイトルが未入力の場合	"Title can’t be blank"とバリデーションメッセージを表示させる。
  validates :title, presence: {message: "Title can’t be blank"}
  # バリデーションに失敗した場合、内容が未入力の場合	"Content can’t be blank"とバリデーションメッセージを表示させる。
  validates :content, presence: {message: "Content can’t be blank"}
end
