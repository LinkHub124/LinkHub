namespace :rss do
  desc "gya!!"
  task hello: :environment do
    ThemesController.new.update_users_ranks
  end
end