namespace :protractor do
  task start: :environment do
    protractor Rails.root.join('config/protractor.js')
  end
end