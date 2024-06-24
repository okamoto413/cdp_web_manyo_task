require 'rails_helper'

  RSpec.describe 'ユーザモデル機能', type: :model do
    describe 'バリデーションのテスト' do
      context 'ユーザの名前が空文字の場合' do
        it 'バリデーションに失敗する' do
          user = FactoryBot.build(:user,name: '')
          expect(user).not_to be_valid
        end
      end

      context 'ユーザのメールアドレスが空文字の場合' do
        it 'バリデーションに失敗する' do
          user = FactoryBot.build(:user, email:'')
          expect(user).not_to be_valid
        end
      end

      context 'ユーザのパスワードが空文字の場合' do
        it 'バリデーションに失敗する' do
          user = FactoryBot.build(:user, password:'')
          expect(user).not_to be_valid
        end  
      end

      context 'ユーザのメールアドレスがすでに使用されていた場合' do
        it 'バリデーションに失敗する' do
          existing_user = FactoryBot.create(:user)
          user = FactoryBot.build(:user, email: existing_user.email)
          user.valid?
          expect(user.errors.full_messages).to include('メールアドレスはすでに使用されています')    
        end
      end

      context 'ユーザのパスワードが6文字未満の場合' do
        it 'バリデーションに失敗する' do
          user = FactoryBot.build(:user, password:'short', password_confirmation: 'short')
          user.valid? 
          expect(user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
        end
      end

      context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
        it 'バリデーションに成功する' do
          user = FactoryBot.build(:user)
          expect(user).to be_valid
        end
      end
    end
  end
