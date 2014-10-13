require 'scrape/base/calendar_scraper'
require 'scrape/ybca/ybca_scraper'
require 'scrape/helpers'

class YbcaCalendar < CalendarScraper
  extend Scrape::Helpers

  SUBTITLE  = '.cluster-field-subtitle'
  TITLE     = '.cluster-field-title'
  BODY      = '.pane-content .body'
  CALLOUT   = '.cluster-field-datespan'
  IMAGES     = '.program-cluster-hero-450'

  scrape_text :subtitle, :title, :callout
  scrape_inner_html :body
  use_scrape_images

  def venue
    Venue.find_by(name: 'Yerba Buena Center for the Arts')
  end

  # @venue = Venue.find_or_create_by(name: YbcaScraper::VENUE_NAME)
  # class << self
  #   attr_reader :venue
  # end

  # def initialize(url, **args)
  #   super
  #   @venue = YbcaCalendar.venue
  # end
end