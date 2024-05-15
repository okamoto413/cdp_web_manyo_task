require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: nil, content: :string)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["Title can't be blank"]    
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: 'タスクタイトル', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: 'タスクタイトル', content: 'タスク説明')
        expect(task).to be_valid        
      end
    end



RSpec.describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      task1 = FactoryBot.create(title: '最初のタスク', content: '最初のタスク説明', created_at: 1.day.ago)
      task2 = FactoryBot.create(title: '2番目のタスク', content: '2番目のタスク説明', created_at:1.hour.ago)
      visit tasks_path
    end

    it 'タスクが作成日時の降順に表示される' do
      visit tasks_pat
      task_taitles=all('.task_title').map(&:text)
        expect(page.text).to eq [@task2.title, @task1.title]
      end
  end
end