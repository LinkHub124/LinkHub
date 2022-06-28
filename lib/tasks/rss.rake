namespace :rss do
  task hello: :environment do
    ThemesController.new.update_rank(10)
    UsersController.new.update_rank(10)
  end
end