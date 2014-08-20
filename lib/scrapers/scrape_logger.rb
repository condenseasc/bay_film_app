module ScrapeLogger 
  include ActiveSupport::TaggedLogging

  # @logger = ActiveSupport::TaggedLogging.new(Logger.new('scrape.log'))

  # attr_accessor :logger

  # def self.new(name)
  #   logger = Logger.new('scrape.log')
  #   venue_name = name
  #   ActiveSupport::TaggedLogging.new(logger)
  # end

  def venue_name(r)
    r.venue.abbreviation || r.venue.name
  end

  def saved_new_record(r)
    tagged("SCRAPER", "#{venue_name r}", "#{r.class}", "SAVE_NEW") do
      info "New #{r.class} #{r.id}"
    end
  end

  def identical_to(persisted)
    tagged("SCRAPER", "#{venue_name persisted}", "#{persisted.class}", "IDENTICAL") do
      info "Identical to #{persisted.class} #{persisted.id}"
    end
  end


  def multiple_duplicates(records)
    tagged("SCRAPER", "#{venue_name records.first}", "#{records.first.class}", "MULTIPLE_DUPLICATES_FOUND") do
      warn "Duplicate #{records.first.class} -> #{records.each { |r| print r.id + "; "}}"
    end
  end

  # based on event updater, attribute array, associations hash {class => id's}
  def updated_record(r, attributes, assocations)
    # if !associations_hash.empty?

    # associations_summary = associations_hash.each { |a| print a.size + " new " + a.key + "; "}}
    tagged("SCRAPER", "#{venue_name r}", "#{r.class}", "UPDATE_RECORD") do
      info "Update #{r.class} #{r.id} -> #{attributes}; #{associations.each { |a| 
      print a.size + " new " + a.key + "; "}} #{associations}"
    end
  end

  def invalid_record(r)
    tagged("SCRAPER", "#{venue_name r}", "#{r.class}", "INVALID") do
      info "Validation errors. #{r.inspect}: #{r.errors.messages}"
    end
  end
end