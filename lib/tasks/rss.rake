namespace :rss do
  task hello: :environment do
    ThemesController.new.update_rank(5)
    UsersController.new.update_rank(5)
  end
end