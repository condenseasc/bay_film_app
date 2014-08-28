# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Venue.create do |v|
  v.name = 'Pacific Film Archive Theater'
  v.abbreviation = 'PFA' 
  v.url = 'http://www.bampfa.berkeley.edu/'
  v.city = 'Berkeley'
end

Venue.create do |v|
  v.name = 'Yerba Buena Center for the Arts'
  v.abbreviation = 'YBCA' 
  v.url = 'http://www.ybca.org/'
  v.city = 'Berkeley'
end