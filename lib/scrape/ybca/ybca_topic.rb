require 'scrape/base/topic_scraper'
require 'scrape/ybca/ybca_scraper'
require 'scrape/helpers'

class YbcaTopic < TopicScraper
  extend Scrape::Helpers

  SUPERTITLE    = ".field-name-field-supertitle"
  SUBTITLE_TEXT = ".program-field-subtitle"
  TITLE         = ".program-field-main-title"
  LOCATION_NOTE = ".program-venue-panel-pane span a:first-child" # it's a link, so use href too #LOCATION || Location text and url
  TIMES         = ".pane-node-field-performance-times .date-display-single"
  BODY          = ".panel-pane-program-overview .body"
  CALLOUT       = '.field-name-field-pullquote'
  IMAGES        = '.program-hero-large-970'

  def venue
    Venue.find_by(name: 'Yerba Buena Center for the Arts')
  end

  scrape_text :title, :supertitle, :subtitle_text, :callout
  scrape_inner_html :body
  use_scrape_images

  def scrape_subtitle
    str = scrape_subtitle_text
    if str == 'Yerba Buena Center for the Arts presents'
      nil
    else
      str
    end
  end

  def scrape_times
    Time.zone = "Pacific Time (US & Canada)"
    doc.css(YbcaTopic::TIMES).map do |node| 
      t = Time.zone.parse( node.text )
    end
  end
end