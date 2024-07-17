FactoryBot.define do
  factory :label do
    name { 'テストラベル' }  # デフォルトのラベル名を設定する例
    association :user  
end
end