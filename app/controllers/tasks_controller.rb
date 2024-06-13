class TasksController < ApplicationController
 
  def index
    # @tasks = Task.all.order(created_at: :desc)
    @tasks = current_user.tasks.order(created_at: :desc)
    # ページネーション：タスク一覧画面にページネーションを実装し、1ページあたり10件のタスクを表示させる
    @task_model_name = t("activerecord.models.task")
    @task_title_attribute = t("activerecord.attributes.task.title")

  
    # @tasks = Task.where(user_id: current_user.id)
    # if current_user
    #   @tasks = current_user.tasks
    # else
    #   @tasks = Task.all
    # end

    # ソート処理   
    if params[:sort_deadline_on]
      @tasks = Task.sorted_by_deadline
    elsif params[:sort_priority]
      # @tasks = Task.sorted_by_priority
      @tasks =Task.sorted_by_priority.order(priority: :desc, created_at: :desc)
    end  
    

    
    if params[:search].present?
      search_params = params[:search]
      if search_params[:title].present? && search_params[:status].present?
        @tasks = @tasks.search_status(search_params[:status]).search_title_like(search_params[:title])
      elsif search_params[:title].present?  
        @tasks = @tasks.search_title_like(search_params[:title])
      elsif search_params[:status].present?
        @tasks = @tasks.search_status(search_params[:status])  
      end
    end
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
    # @task = Task.find(params[:id])
      @task = current_user.tasks.find(params[:id])
  end  

  def new
    @task = Task.new
  end    

  def edit
    @task = current_user.tasks.find(params[:id])

  end
  
    # 一覧画面（ログイン中のユーザーのタスクのみ表示する）
  def create
    # @task = Task.new(task_params)
     @task = current_user.tasks.new(task_params)
    if @task.save 
      #登録された場合、タスク一覧画面へ遷移する
      redirect_to tasks_path(@task)
    else
      render :new
      return
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      #タスクの更新に成功した場合	Task was successfully updated.のフラッシュメッセージを表示させる。
      flash[:notice]= t("flash_messages.task_updated")
      #タスク詳細画面へ遷移。
      redirect_to task_path(params[:id])
    else
      render :edit   
    end    
  end  

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    #タスクを削除した場合	Task was successfully destroyed.のフラッシュメッセージを表示させる。
    flash[:notice]= t("flash_messages.task_destroyed")
    #削除後、タスク一覧画面へ画面遷移する。
    redirect_to tasks_path
  end  
  
  private

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status,)
  end

  def search_tasks(search_params)
    tasks = Task.all
    tasks = tasks.where("title LIKE ?", "%#{search_params[:title]}%") if search_params[:title].present?
    tasks = tasks.where(status: search_params[:status])
    if search_params[:status].present?
    tasks
    end
  end
end