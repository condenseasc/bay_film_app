require 'scrapers/scrape'

class ScrapedSeries
  include Scrape
  # maximal list of scraping methods
  SCRAPE_METHODS = %w[scrape_title scrape_description]
  # maximal list of attributes written by scrapers
  attr_reader :title, :description
  # initialized properties, with venue being provided
  attr_reader :url, :doc, :logger, :venue

  def initialize(url)
    @url = url
    @doc = make_doc url 
    @logger = VenueScraper.logger
  end

  # defined on VenueScraper too...
  def urls(selector)
    find_urls doc, selector
  end

  def scrape
    scrape_title
    scrape_description
    puts title
  end

  def create_record
    s = Series.new do |s|
      s.title       = title
      s.description = description
      s.venue       = venue
      s.url         = url
    end
    save_record(s)
  end

  # if it's already in the db, then check if there are differences, update if necessary,
  # and in any case REPLACE the series in 
  # hm... how can I give events the correct series? I guess just use... title on the venue, since that's controlled and unique.
  def save_record(r)
    if r.valid?
      r.save!
    elsif r.errors.size == 1 && r.errors[:title][0] == 'already taken at this venue'
      persisted_series = Series.where(title: r.title, time: r.time, venue: r.venue)
      if persisted_series.length > 1
        logger.multiple_duplicates_found(r)
        raise DuplicateRecordError.new, "Multiple duplicate records for series"
      else
        persisted = persisted_series[0]
      end
      # Get a hash of attributes and a hash of :association => [records]
      attributes = Compare::Records.attribute_difference(persisted, r, Compare::Records::SERIES_EXCLUSIONS)
      hash = {}
      UPDATEABLE_ASSOCIATIONS.each do |name|
        hash[name] = Compare::Records.association_difference(persisted.send(name), r.send(name))
        hash.delete(name) if hash[name].empty?
      end
      associations = hash
      # Update only if there's a difference. Note: this test prunes the associations hash
      if attributes.empty? && associations.empty?
        logger.identical_to(persisted)
        return persisted
      else
        logger.update_record(r, attributes, associations)
        associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
        if persisted.update!(attributes) then persisted else false end
      end
    else
      logger.invalid_record(r)
      return nil
    end
  end

  def method_missing(method_id, *args)
    if ScrapedSeries::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    else
      super
    end
  end
end