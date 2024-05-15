class TasksController < ApplicationController

  def index
    @tasks = Task.all
    @task_model_name = t("activerecord.models.task")
    @task_title_attribute = t("activerecord.attributes.task.title")
  end

  def show
    @task = Task.find(params[:id])
  end  

  def new
    @task = Task.new
  end    

  def edit
    @task = Task.find(params[:id])
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save 
      #タスクの登録に成功した場合	Task was successfully created.のフラッシュメッセージを表示させる     
      flash[:notice]= t("flash_messages.task_created")
      #登録された場合、タスク一覧画面へ遷移する
      redirect_to tasks_path(@task)
    else
      render :new
      return
    end
  end

  def update
    @task = Task.find(params[:id])
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
    @task = Task.find(params[:id])
    @task.destroy
    #タスクを削除した場合	Task was successfully destroyed.のフラッシュメッセージを表示させる。
    flash[:notice]= t("flash_messages.task_destroyed")
    #削除後、タスク一覧画面へ画面遷移する。
    redirect_to tasks_path
  end  
  
  private

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content)
  end
end