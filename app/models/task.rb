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

  # 検索機能のscope定義
  scope :status, ->(status) { where(status: status)}
  scope :tasks_title_like, ->(title) {where( "title LIKE ?", "%#{title}%")}

  #10.リファクタリング
  #ソートロジックをtasksコントローラからTasksモデルへ移動
  scope :sorted_by_deadline, -> {order(deadline_on: :asc)}
  scope :sorted_by_priority, -> {order(priority: :desc)}
  scope :title_like, ->(title) { where('title LIKE ?', "%#{title}%")}
  #作成日時の新しい順に並び替えるロジックをTaskモデルに移すこ
  scope :recently_created, -> { order(created_at: :desc) } 

  #検索ロジックをtasksコントローラからTaskモデルに移す
  def self.seach(params)
    tasks = Task.all
    tasks = tasks.title_like(params[:task_title]) if params[:task_title].present?
    tasks = tasks.with_status(params[:status]) if params[:status].present?
    tasks
  end
end
