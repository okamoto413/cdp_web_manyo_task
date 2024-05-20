# config/initializers/locale.rb

# I18nライブラリに訳文の探索場所を指示する
# I18n.load_path += Dir[Rails.root.join('config/locales/*.rb')]
I18n.load_path += Dir[Rails.root.join('config/locales/*.yml')]

I18n.default_locale = :ja