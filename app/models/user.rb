class User < ApplicationRecord
  before_save :downcase_email
  has_secure_password
  
 #ユーザとタスクをアソシエーションし、タスク一覧画面には自分が作成したタスクのみを表示させる
  has_many :tasks, dependent: :destroy

#機能要件：名前が未入力の場合	
  validates :name, presence: true
#機能要件：メールアドレスが未入力の場合	
  validates :email, presence: true, uniqueness: true
# 機能要件：メールアドレスがすでに使用されていた場合
#   validates :email, uniqueness: {message:"メールアドレスはすでに使用されています"}

#機能要件：パスワードが未入力の場合
#機能要件：パスワードが6文字未満の場合
  validates :password,presence:true, length: { minimum: 6}, if: -> { password_required? }
  # validates :password, presence: {message:"パスワードは6文字以上で入力してください"},length: { minimum: 6}
    validates :password_confirmation, presence: true, if: -> { password_required? }
  #機能要件：パスワードとパスワード（確認）が一致しない場合	
  validates_confirmation_of :password
  
  #削除前に削除防止コールバック（ def ensure_at_least_one_admin）でチェックする
  before_destroy :ensure_at_least_one_admin
  #変更の前に管理者権限変更防止コールバック（ensure_at_least_one_admin_on_update）でチェックする
  before_update :ensure_at_least_one_admin_on_update, if: :will_save_change_to_admin?

  private

  def downcase_email
    self.email = email.downcase
  end

  def password_required?
    new_record? || password.present?
  end

  def ensure_at_least_one_admin
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw(:abort)  #処理を停止
    end
  end

  # 管理者が一人しかいない場合の管理者権限変更防止コールバック
  def ensure_at_least_one_admin_on_update
    if User.where(admin: true).count == 1 && self.admin? && !admin_was
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw(:abort)
    end
  end
end    