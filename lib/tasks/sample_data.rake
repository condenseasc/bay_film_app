namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_venues
    make_events
  end

  def make_venues
    10.times do
      name = "#{Faker::Company.name} Cineplex"
      city = ["Oakland", "Berkeley", "San Francisco"].sample
      website = "www.#{Faker::Company.bs}.com"
      street_address = Faker::Address.street_address( include_secondary = false )
      description = Faker::Lorem.paragraph( sentence_count = 4 )

      Venue.create!(name: name, city: city, website: website, 
        street_address: street_address, description: description)
    end
  end

  def make_events

  end
end