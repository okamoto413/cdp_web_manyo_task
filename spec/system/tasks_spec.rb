require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '一覧表示機能' do
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
   let!(:first_task) { FactoryBot.create(:task, title: 'first_task', content: 'first_task', priority: :high, status: :not_started, created_at: 1.day.ago)}
   let!(:second_task) { FactoryBot.create(:second_task, title: 'second_task',  content: '2番目のタスク説明', status: :started, created_at:1.hour.ago)}
   let!(:third_task) { FactoryBot.create(:third_task, title: 'third_task', content: '3番目のタスク説明', status: :completed, created_at:1.minute.ago)}
  #new_task追記
   let!(:new_task) { FactoryBot.create(:task, title: 'new_task') } 

   # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
   before do
     visit tasks_path
    end

     context '一覧画面に遷移した場合' do
    #  it '作成済みのタスク一覧が表示される' do
    #     task = FactoryBot.create(:task, title: 'task')
    #   end
     it '作成済みのタスク一覧が作成日時の降順で表示される' do
          task_list = all('tbody tr')
          # binding.irb
          expect(task_list[0]).to have_content 'new_task'
          expect(task_list[1]).to have_content 'third_task'
          expect(task_list[2]).to have_content 'second_task'
          expect(task_list[3]).to have_content 'first_task'
        end

      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        Task.create!(title: '書類作成', content: '企画書を作成する。', priority: :high, status: :not_started, created_at: 1.day.ago, deadline_on: '2022-02-16 12:00:00 +0900')
        # FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end

      #System Specにテスト項目を追加(STEP3)
  describe 'ソート機能' do
    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
      # allメソッドを使って複数のテストデータの並び順を確認する
        click_link '終了期限'
        save_and_open_page
        task_deadlines = all('.task_deadline').map(&:text)
        expect(task_deadlines).to eq [ "2022-02-16", "2022-02-17", "2025-02-10", "2025-02-10"]
      end
    end

    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
         # allメソッドを使って複数のテストデータの並び順を確認する
        visit tasks_path
        click_link '優先度'
        task_priorities  = all('.task_priority').map(&:text)
        expect(task_priorities).to eq ["高", "高", "中", "低"]
      end
    end
  end

  describe '検索機能' do
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
      # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        visit tasks_path
        fill_in 'search_title', with: 'first'
        click_button '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
        expect(page).not_to have_content 'third_task'
      end
    end

    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
      visit tasks_path  
      # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      # fill_in 'search_status', with: 'not_started'
      select '未着手', from: 'search_status'
      click_button '検索'
      expect(page).to have_content 'first_task'
      expect(page).not_to have_content 'second_task'
      expect(page).not_to have_content 'third_task'
    end
    end

    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
      # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        fill_in 'search_title', with: 'first'
        select '未着手', from: 'search_status'
        click_button '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
        expect(page).not_to have_content 'third_task'
      end
    end
  end

   context '新たにタスクを作成した場合' do
     it '新しいタスクが一番上に表示される' do
       visit new_task_path
         fill_in 'task_title', with:'new_task'
         fill_in 'task_content', with:'タスク内容'
         fill_in 'task_deadline_on', with:'2025-02-10'
         select '未着手', from: 'task_status' 
         select '高', from: 'task_priority'
         click_button '登録する' 
         visit tasks_path 
         task_list = all('tbody tr')
         expect(task_list[0]).to have_content 'new_task'
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