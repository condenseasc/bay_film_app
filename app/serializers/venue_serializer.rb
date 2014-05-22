class VenueSerializer < ActiveModel::Serializer
  attributes :id, :name, :abbreviation, :city
end
