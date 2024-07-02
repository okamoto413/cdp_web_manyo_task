class User < ApplicationRecord
  #メールアドレスを小文字に変換
  before_validation :downcase_email
  has_secure_password
  #管理者が一人しかいない状態の場合.コールバックで削除を制御
  before_destroy :ensure_an_admin_remains, prepend: true
  #コールバックで管理者権限の変更を制御
  before_update :ensure_an_admin_remains_if_admin_changed, if: :admin_cahnged?

  
 #ユーザとタスクをアソシエーションし、タスク一覧画面には自分が作成したタスクのみを表示させる
  has_many :tasks, dependent: :destroy

#機能要件：名前が未入力の場合	
  validates :name, presence: true
#機能要件：メールアドレスが未入力の場合	
#メールアドレスがすでに使用されていた場合,大文字小文字を区別しない設定を追加
  validates :email, presence: true, uniqueness: {case_sensitive: false}

#機能要件：パスワードが未入力の場合
#機能要件：パスワードが6文字未満の場合
  validates :password,presence: true, length: { minimum: 6}
#   パスワードが存在しない場合、バリデーションを適用する
 # if: -> {new_record? || !password.nil? }
  #機能要件：パスワードとパスワード（確認）が一致しない場合	

  
  #削除前に削除防止コールバック（ def ensure_at_least_one_admin）でチェックする
  before_destroy :ensure_at_least_one_admin
  #変更の前に管理者権限変更防止コールバック（ensure_at_least_one_admin_on_update）でチェックする
  before_update :ensure_at_least_one_admin_on_update, if: :will_save_change_to_admin?

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def password_required?
    new_record? || password.present?
  end

  #管理者が一人しかいない状態の場合.コールバックで削除を制御
  #コールバックで管理者権限の変更を制御
  def ensure_an_admin_remains
    if User.where(admin: true).count <= 1
      errors.add(:base, I18n.t(errors.messages.cannot_delete_last_admin))
      throw(:abort)
    end
  end  



  # def ensure_at_least_one_admin
  #   if User.where(admin: true).count == 1 && self.admin?
  #     errors.add(:base, "管理者が0人になるため権限を変更できません")
  #     throw(:abort)  #処理を停止
  #   end
  # end

  # 管理者が一人しかいない場合の管理者権限変更防止コールバック
  def ensure_an_admin_remains_if_admin_changed
    if User.where(admin: true).count == 1 && self.admin? && !admin_was
      errors.add(base, I18n.t(errors.messages.cannot_change_last_admin))
      throw(:abort)
    end
  end
end    