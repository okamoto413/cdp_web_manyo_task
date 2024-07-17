 require 'rails_helper'
 RSpec.describe 'ラベル管理機能', type: :system do
   
    let!(:user) { FactoryBot.create(:user) }  
    let!(:label) { FactoryBot.create(:label, name: 'テストラベル', user: user ) }  
 
    before do
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    end 

    describe '登録機能' do
     context 'ラベルを登録した場合' do
       it '登録したラベルが表示される' do
          visit new_label_path
          fill_in '名前', with: '新しいラベル'
          click_button '登録する'
          expect(page).to have_content '新しいラベル'
       end
     end
   end

   describe '一覧表示機能' do
     context '一覧画面に遷移した場合' do
       it '登録済みのラベル一覧が表示される' do
          FactoryBot.create(:label, name: 'ラベル1', user: user )
          FactoryBot.create(:label, name: 'ラベル2', user: user )
          visit labels_path
          expect(page).to have_content 'ラベル1'
          expect(page).to have_content 'ラベル2'
        end
     end
   end
 end