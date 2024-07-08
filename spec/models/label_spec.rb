 require 'rails_helper'

 RSpec.describe 'ラベルモデル機能', type: :model do
   describe 'バリデーションのテスト' do
     context 'ラベルの名前が空文字の場合' do
       it 'バリデーションに失敗する' do
         label = FactoryBot.build(:label, name: '')
         expect(label).not_to be_valid
         expect(user.errors.full_messages).to include('名前を入力してください')    
       end
     end

     context 'ラベルの名前に値があった場合' do
       it 'バリデーションに成功する' do
         label =  FactoryBot.build(:label, name: 'テストラベル')
         expect(label).to be_valid
       end
     end
   end
 end