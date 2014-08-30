require 'scrapers/scrape'

class ScrapedSeries
  include Scrape
  # maximal list of scraping methods
  SCRAPE_METHODS = %w[scrape_title scrape_description]
  # maximal list of attributes written by scrapers
  SERIES_METHODS = %w[title description]
  attr_reader :url, :doc, :logger, :venue, :series

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
    @series = Series.new do |s|
      s.title = scrape_title
      s.description = scrape_description
      s.venue = venue
      s.url = url
    end
    # @stills = scrape_stills
    puts title
  end

  def save
    save_record
  end

  # if it's already in the db, then check if there are differences, update if necessary,
  # and in any case REPLACE the series in 
  # hm... how can I give events the correct series? I guess just use... title on the venue, since that's controlled and unique.
  def save_record
    if series.valid?
      series.save!
    elsif series.errors.size == 1 && r.errors[:title][0] == 'already taken at this venue'
      persisted_series = Series.where(title: series.title, venue: series.venue)
      if persisted_series.length > 1
        logger.multiple_duplicates_found(series)
        raise DuplicateRecordError.new, "Multiple duplicate records for series"
      else
        persisted = persisted_series[0]
      end
      # Get a hash of attributes and a hash of :association => [records]
      attributes = Compare::Records.attribute_difference(persisted, series, Compare::Records::SERIES_EXCLUSIONS)
      hash = {}
      UPDATEABLE_ASSOCIATIONS.each do |name|
        hash[name] = Compare::Records.association_difference(persisted.send(name), series.send(name))
        hash.delete(name) if hash[name].empty?
      end
      associations = hash
      # Update only if there's a difference. Note: this test prunes the associations hash
      if attributes.empty? && associations.empty?
        logger.identical_to(persisted)
        return persisted
      else
        logger.update_record(series, attributes, associations)
        associations.each { |key, value| persisted.send(key) << value } unless associations.empty?
        if persisted.update!(attributes) then persisted else false end
      end
    else
      logger.invalid_record(series)
      return nil
    end
  end

  def method_missing(method_id, *args)
    if ScrapedSeries::SCRAPE_METHODS.include?(method_id.id2name)
      nil
    elsif ScrapedSeries::SERIES_METHODS.include?(method_id.id2name)
      series.send(method_id, *args)
    else
      super
    end
  end
end