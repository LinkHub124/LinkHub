namespace :rss do
  task hello: :environment do
    UsersController.new.create_rank(10)
    UsersController.new.update_rank
  end
end