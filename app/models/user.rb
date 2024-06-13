class User < ApplicationRecord
  before_save :downcase_email
  has_secure_password
  
 #ユーザとタスクをアソシエーションし、タスク一覧画面には自分が作成したタスクのみを表示させる
  has_many :tasks, dependent: :destroy

#機能要件：名前が未入力の場合	
  validates :name, presence:  {message:"名前を入力してください"}

#機能要件：メールアドレスが未入力の場合	
  validates :email, presence: {message:"メールアドレスを入力してください"}, length: { maximum: 255 }, uniqueness: true

#機能要件：メールアドレスがすでに使用されていた場合
  validates :email, presence: {message:"メールアドレスはすでに使用されています"}, uniqueness: true
  before_validation { email! }

#機能要件：パスワードが未入力の場合
  validates :password,presence: {message:"パスワードを入力してください"}
#機能要件：パスワードが6文字未満の場合
  validates :password, presence: {message:"パスワードは6文字以上で入力してください"},length: { minimum: 6}

#機能要件：パスワードとパスワード（確認）が一致しない場合	
  validates :password_confirmation, presence: {message:"パスワード（確認）とパスワードの入力が一致しません"},uniqueness: true

  private

  def downcase_email
    self.email = email.downcase
  end
end    