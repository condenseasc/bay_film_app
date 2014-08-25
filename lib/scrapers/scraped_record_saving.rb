module ScrapedEvent
    def save_scraped_record
    if e.valid?
      e.save!
      logger.saved_new_record(e)
      return e
    elsif e.errors.size === 1 &&
      e.errors[:title][0] === "already exists at this screening time and venue"
      # Paranoid? Checking if something screwy led to duplicate persisted records.
      # Maybe split this into a different rake task with teeth to check and delete them?
      persisted_events = Event.where(title: e.title, time: e.time, venue: e.venue)
      if persisted_events.length > 1
        logger.multiple_duplicates_found(e)
        raise DuplicateRecordError.new, "Multiple duplicate records for event"
      else
        persisted = persisted_events[0]
      end
      # Get a hash of attributes and a hash of :association => [records]
      attributes = Event.attribute_difference(persisted, e)
      hash = {}
      UPDATEABLE_ASSOCIATIONS.each do |name|
        hash[name] = Event.association_difference(persisted.send(name), e.send(name))
        hash.delete(name) if hash[name].empty?
      end
      associations = hash
      # Update only if there's a difference. Note: this test prunes the associations hash
      if attributes.empty? && associations.empty?
        logger.identical_to(persisted)
        return persisted
      else
        logger.update_record(e, attributes, associations)
        associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
        if persisted.update!(attributes) then persisted else false end
      end
    else
      logger.invalid_record(e)
      return nil
    end
  end
end