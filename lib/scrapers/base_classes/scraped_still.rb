require 'scrapers/base_classes/venue_scraper'
require 'local_resource'
require 'compare'

class ScrapedStill
  attr_accessor :url, :alt, :logger

  def initialize(url=nil, alt=nil)
    @url = url
    @alt = alt
    @logger = VenueScraper.logger
    yield self
    # block.call(self)
  end

  def build_record
    Still.new do |s|
      s.url = url
      s.alt = alt
      s.image = LocalResource.file_from_url(url).open
      # LocalResource.with_file_from_url(url) do |f|
      #   s.image = f.open
      # end
    end
  end

  # Good to have around since most images will be shared between
  # series and events
  def save_still_to(record)
    s = build_record

    if !s.valid?
      logger.invalid_record(s)
    # elsif record.stills.empty? # not actually necessary, empty array funnels it to the last condition
    #   record.stills << self
    else
      match = false
      record.stills.each do |p|
        if Compare::Images.duplicate?(p.image.path, s.image.path)
          match = true
          if p.image.size < s.image.size
            p.image = s.image
          end
          s.image.close
          s.image.unlink
        end
      end
      record.stills << s unless match
    end
  end
end

  # add handling for unlinking
  # that's if ' it fails

#     if record.stills.length == 0
#       record.
#     # check for duplicates against said record's stills
#     record.stills <<
#   end
# end  
#   def save_scraped_stills(scraped_stills)
#     persisted_stills = stills.to_a
#     # if no stills, no more tests necessary, all new stills are valid
#     if persisted_stills.empty?
#       stills << scraped_stills
#     else
#       scraped_stills.each do |scraped|
#         match = false
#         persisted_stills.each do |persisted|
#           if Compare::Images.duplicate?(persisted.image.path, scraped.image.path) &&
#             scraped.image.size > persisted.image.size
#             match = true
#             persisted.image = scraped.image
#           end
#         end
#         stills << scraped unless match
#       end
#     end
  #   save
  # end

  # valid?
  # # save
  # elsif duplicate
  # # check for multiple duplicates (error!)
  # # check for and makes updates
  # else
  # # invalid, logs errors
  # def save_scraped_record(r)
  #   if r.valid?
  #     r.save!
  #     logger.saved_new_record(r)
  #     return r
  #   elsif r.errors.size == 1 && r.errors[:title][0] == "already exists at this screening time and venue"
  #     # Paranoid? Checking if something screwy led to duplicate persisted records.
  #     # Maybe split this into a different rake task with teeth to check and delete them?
  #     persisted_events = Event.where(title: r.title, time: r.time, venue: r.venue)
  #     if persisted_events.length > 1
  #       logger.multiple_duplicates_found(r)
  #       raise DuplicateRecordError.new, "Multiple duplicate records for event"
  #     else
  #       persisted = persisted_events[0]
  #     end
  #     # Get a hash of attributes and a hash of :association => [records]
  #     attributes = Compare::Records.attribute_difference(persisted, r, Compare::Records::EVENT_EXCLUSIONS)
  #     hash = {}
  #     UPDATEABLE_ASSOCIATIONS.each do |name|
  #       hash[name] = Compare::Records.association_difference(persisted.send(name), r.send(name))
  #       hash.delete(name) if hash[name].empty?
  #     end
  #     associations = hash
  #     # Update only if there's a difference. Note: this test prunes the associations hash
  #     if attributes.empty? && associations.empty?
  #       logger.identical_to(persisted)
  #       return persisted
  #     else
  #       logger.update_record(r, attributes, associations)
  #       associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
  #       if persisted.update!(attributes) then persisted else false end
  #     end
  #   else
  #     logger.invalid_record(r)
  #     return nil
  #   end
  # end

