require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.new(title: '', content: :string, user: user)
        expect(task).to be_invalid
        expect(task.errors.full_messages).to eq ["タイトルを入力してください", "終了期限を入力してください", "優先度を入力してください", "ステータスを入力してください"]    
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: 'タスクタイトル', content: '', user: user)
        expect(task).not_to be_valid
        expect(task.errors.full_messages).to eq ["内容を入力してください", "終了期限を入力してください", "優先度を入力してください", "ステータスを入力してください"]
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(
          title: 'タスクタイトル', 
          content: 'タスク説明',
          deadline_on: Time.zone.tomorrow, 
          priority: :high, 
          status: :not_started,
          user: user              
        )
        expect(task).to be_valid
      end
    end
  end  

  describe '検索機能' do
    # テストデータを複数作成する
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', deadline_on:'2022-02-18', priority:'medium', status:'not_started', user: user )}
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", deadline_on:	'2022-02-17', priority:'high', status:'started', user: user ) }
   
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
         # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        expect(Task.search_title_like('first')).to include(first_task)
        expect(Task.search_title_like('first')).not_to include(second_task)
        expect(Task.search_title_like('first').count).to eq 1
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status('not_started')).to include(first_task)
        expect(Task.search_status('not_started')).not_to include(second_task)
        expect(Task.search_status('not_started').count).to eq 1
      end
    end         

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
         # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
         # 検索されたテストデータの数を確認する
        expect(Task.search_title_like('first').search_status('not_started')).to include(first_task)
        expect(Task.search_title_like('first').search_status('not_started')).not_to include(second_task)
        expect(Task.search_title_like('first').search_status('not_started').count).to eq 1
      end
    end
  end
end

