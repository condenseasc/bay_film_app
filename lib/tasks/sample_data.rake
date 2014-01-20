namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_venues
    make_events
    make_event_venue_associations
    make_series
    make_series_associations
  end

  def make_venues
    10.times do
      name = "#{Faker::Company.name} Cineplex"
      city = ["Oakland", "Berkeley", "San Francisco"].sample
      url = "www.#{Faker::Company.bs}.com"
      street_address = Faker::Address.street_address( include_secondary = false )
      description = Faker::Lorem.paragraph( sentence_count = 4 )

      Venue.create!(name: name, city: city, url: url, 
        street_address: street_address, description: description)
    end
  end

  def make_series
    10.times do
      title = "Films by #{Faker::Name.name}"
      description = Faker::Lorem.paragraph( sentence_count = 2 )
      Series.create!(title: title, description: description)
    end
  end

  def make_events
    100.times do
      # venues = Venue.last(10)

      title = Faker::Lorem.words( num = 3 ).join( ' ' )
      time = Time.now.advance( hours:  Random.rand(500) )
      description = Faker::Lorem.paragraph( sentence_count = 7 )
      venue = Venue.all.sample

      Event.create!( title: title, time: time, description: description, venue: venue)
    end
  end

  def make_event_venue_associations
    venues = Venue.all
    events = Event.all

    events.each do |e|
      unless e.venue
        venues.sample.events << e
      end
    end
  end

  def make_series_associations
    venues = Venue.all.to_a
    events = Event.all.to_a
    series = Series.all.to_a

    5.times do 
    end

    # distributed series
    5.times do
      s = series.pop
      10.times { s.events << events.pop }
    end

    # venue specific series
    5.times do
      v = venues.pop
      s = series.pop
      v.series<<s
      v.events.each { |e| s.events << e }
    end
  end
end