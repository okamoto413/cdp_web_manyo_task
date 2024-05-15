require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '一覧表示機能' do
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
   let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2024-05-15 12:34:48 +0900')}
   let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2024-05-15 11:26:28 +0900')}
   let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2024-05-15 11:26:16 +0900')}

   # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
   before do
     visit tasks_path
    end

     context '一覧画面に遷移した場合' do
    #  it '作成済みのタスク一覧が表示される' do
    #     task = FactoryBot.create(:task, title: 'task')
    #   end

     it '作成済みのタスク一覧が作成日時の降順で表示される' do
          task_list = all('body tr')
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'second_task'
          expect(task_list[3]).to have_content 'third_task'
      end

      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        Task.create!(title: '書類作成', content: '企画書を作成する。')
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end

   context '新たにタスクを作成した場合' do
     it '新しいタスクが一番上に表示される' do
       task = FactoryBot.create(:task, title: 'task')
       visit new_task_path
        fill_in 'タイトル', with:'new_task'
        fill_in '内容', with:'新しいタスクの内容' 
        click_button '登録する' 
        task_list = all('body tr')
        expect(task_list[1]).to have_content 'new_task'
      end
    end    
  end
  
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
      # FactoryBotを使用してタスクのインスタンスを生成
      task = FactoryBot.create(:task, title: '詳細タスク', content:'詳細内容')
      visit task_path(task)
      expect(page).to have_content '詳細タスク'
      expect(page).to have_content '詳細内容'
      end
    end
  end
end