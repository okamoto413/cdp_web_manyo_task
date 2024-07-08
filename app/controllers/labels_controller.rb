class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]

  def index
    @labels = current_user.labels
  end

  def new
    @label = Label.new
  end

  def create
    @user = current_user
     @label = @user.labels.build(label_params)
    if @label.save
      flash[:success] = "ラベルを登録しました"
      #登録された場合、ラベル一覧画面へ遷移する
      redirect_to labels_path
    else
      render :new
    end  
  end

  def edit
    @label = Label.find(params[:id])
  end

  def update
      @label = Label.find(params[:id])
    if @label.update(label_params)
      flash[:notice]= "ラベルを更新しました"
      redirect_to labels_path
    else
      render :edit
    end
  end  
  
  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    flash[:success] = "ラベルを削除しました"
    redirect_to labels_path
  end

  private
  def set_label 
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
