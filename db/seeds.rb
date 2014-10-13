Venue.find_or_create_by(name: 'Pacific Film Archive Theater') do |v|
  v.abbreviation = 'PFA' 
  v.url = 'http://www.bampfa.berkeley.edu'
  v.city = 'Berkeley'
end

Venue.find_or_create_by(name: 'Yerba Buena Center for the Arts') do |v|
  v.abbreviation = 'YBCA' 
  v.url = 'http://www.ybca.org'
  v.city = 'Berkeley'
end