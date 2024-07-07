class User < ApplicationRecord
  #メールアドレスを小文字に変換
  before_validation :downcase_email
  has_secure_password
  #ユーザとタスクをアソシエーションし、タスク一覧画面には自分が作成したタスクのみを表示させる
   has_many :tasks, dependent: :destroy
   
   has_many:labels

  #管理者が一人しかいない状態の場合.コールバックで削除を制御
  before_destroy :ensure_an_admin_remains, prepend: true
  #コールバックで管理者権限の変更を制御
  before_update :ensure_an_admin_remains_if_admin_changed, if: :admin_changed?

#機能要件：名前が未入力の場合	
  validates :name, presence: true
#機能要件：メールアドレスが未入力の場合	
#メールアドレスがすでに使用されていた場合,大文字小文字を区別しない設定を追加
  validates :email, presence: true, uniqueness: {case_sensitive: false}

#機能要件：パスワードが未入力の場合、パスワードが6文字未満の場合、パスワードとパスワード（確認）が一致しない場合
  validates :password,presence: true, length: { minimum: 6}
  
  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def password_required?
    new_record? || password.present?
  end

  #管理者が一人しかいない状態でそのユーザを削除しようとした場合
  def ensure_an_admin_remains
    if User.where(admin: true).count <= 1 && admin?
      errors.add(:base, I18n.t("errors.messages.cannot_delete_last_admin"))
      throw(:abort)
    elsif !admin?
      return true
    end
  end  

  # 管理者が一人しかいない場合
  def ensure_an_admin_remains_if_admin_changed
    if admin_was && !admin? && User.where(admin: true).count == 1 
      errors.add(:base, I18n.t("errors.messages.cannot_change_last_admin"))
      throw(:abort)
    end
  end
end    