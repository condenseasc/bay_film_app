namespace :run_scrapers do 

  desc "run ybca scraper from current path"
  task :ybca do
    on roles :all do
      execute "cd #{current_path} && RAILS_ENV=production #{fetch :rbenv_prefix} bundle exec rake scrape:ybca"
    end
  end

  desc "run pfa scraper from current path"
  task :pfa do
    on roles :all do
      execute "cd '#{current_path}' && RAILS_ENV=production #{fetch :rbenv_prefix} bundle exec rake scrape:pfa"
    end
  end

  desc "run all scrapers from current path"
  task :all do

  end
end