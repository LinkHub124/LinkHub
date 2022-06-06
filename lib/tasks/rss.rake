namespace :rss do
  desc "gya!!"
  task hello: :environment do
    rss_ranking_update = ThemesController.new
    rss_ranking_update.update_users_ranks
  end
end