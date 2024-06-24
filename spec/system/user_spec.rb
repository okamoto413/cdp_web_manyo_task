require 'rails_helper'

  RSpec.describe 'ユーザ管理機能', type: :system do
    describe '登録機能' do
      context 'ユーザを登録した場合' do
        it 'タスク一覧画面に遷移する' do
          user = FactoryBot.create(:user, name: 'Valid User', email: 'valid@example.com', password: 'password')
        
          visit new_session_path
          # ログイン
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: user.password
          click_button 'ログイン'

          expect(page).to have_content 'タスク一覧'
          expect(current_path).to eq tasks_path
        end
      end

      context 'ログインせずにタスク一覧画面に遷移した場合' do
        it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
          visit new_session_path
        
          expect(current_path).to eq new_session_path
          expect(page).to have_content 'ログインしてください'
        end
      end
    end

    describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user, name: 'Valid User',email:'valid@example.com',  password: 'password')}

    context '登録済みのユーザでログインした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
        expect(current_path).to eq tasks_path
      end
      
      it '自分の詳細画面にアクセスできる' do
        visit user_path(user)
        expect(current_path).to eq user_path(user) 
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        other_user = FactoryBot.create(:user)
        visit user_path(other_user)
        expect(current_path).to eq tasks_path
      end  

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe '管理者機能' do
    let!(:admin) { FactoryBot.create(:user, :admin, email: 'admin@example.com') }
    let!(:user) { FactoryBot.create(:user, email: 'user@example.com') }


    context '管理者がログインした場合' do
      before do
        visit new_session_path
        # ログイン
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit tasks_path
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in '名前', with: 'New Admin'
        fill_in 'メールアドレス', with: 'newadmin@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'
      
        expect(page).to have_content 'ユーザを作成しました'
        expect(User.last.admin?).to be true
      end
      
      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user)
        expect(current_path).to eq admin_user_path(user)
      end
      
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit admin_user_path(user)
        fill_in '名前', with: user.name
        click_button '更新する'

        expect(page).to have_content 'ユーザを更新しました'
        expect(user.reload.name).to eq 'Update User' 
      end
      
      it 'ユーザを削除できる' do
        visit admin_users_path
        within "#user-#{user.id}" do         
          click_link '削除'
        end

        expect(page).to have_content 'ユーザを削除しました'
        expect(User.exists?(user.id)).to be false
      end
    end
    
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
      visit new_session_path
      # ログイン
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit tasks_path
    end

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
      visit
      expect(current_path).to eq tasks_path 
      expect(page).to have_content '管理者以外アクセスできません'
      end
    end
  end
end