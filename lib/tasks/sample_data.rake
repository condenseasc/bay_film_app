namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_venues
    make_events
    make_event_venue_associations
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
    100.times do
      # venues = Venue.last(10)

      title = Faker::Lorem.words( num = 3 ).join( ' ' )
      time = Time.now.advance( hours:  Random.rand(500) )
      description = Faker::Lorem.paragraph( sentence_count = 7 )

      Event.create!( title: title, time: time, description: description )
    end
  end

  def make_event_venue_associations
    venues = Venue.all
    events = Event.all

    events.each do |e|
      unless e.venue
        venues.sample.events<<e
      end
    end
  end
end