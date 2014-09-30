require 'scrape/pfa/pfa_scraper'
require 'scrape/helpers'

class PfaEvent < ScrapedEvent
  extend Scrape::Helpers

  TITLE             = "#sub_maintext span"
  DATE_TEXT         = ".sub_wrapper div:nth-child(3)"
  TIME_TEXT         = ".sub_wrapper tr:nth-child(1) td:nth-child(1)"
  DATE_NO_IMG       = "#sub_maintext div+ div"
  TEXT_BLOB_WRAPPER = ".sub_wrapper"
  TEXT_BLOB         = ".sub_wrapper p"
  TEXT_BLOB_CALLOUT = ".ldheader"
  SUBTITLE          = ".sub_wrapper tr:nth-child(1) td:nth-child(2)" #minus the title
  IMG               = ".media img"


  class << self
    attr_reader :venue
  end
  @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)

  ###

  def initialize(url, series:nil, path:nil)
    super
    @venue = PfaEvent.venue
  end

  scrape_text :title, :time_text, :date_text, :date_no_img
  scrape_inner_html :text_blob, :text_blob_callout, :text_blob_wrapper

  def scrape_body
    wrapper = scrape_text_blob_wrapper
    if /ldheader/.match(wrapper)
      desc = wrapper.partition(/<div.+class=.*"ldheader">.*<\/div>/m)[2]
      self.callout = @callout = scrape_text_blob_callout
    else
      desc = scrape_text_blob
      desc = desc.gsub /<\/?p>/, '' # <p> just wraps the text
      # desc = scrape_text_blob.gsub /<\/?p>/, '' # <p> just wraps the text
    end

    # format description with <p> tags instead of <br>
    formatted = ""
    d = desc.split "<br>"
    d.reject! { |string| string.strip.empty? }
    d.each { |s| formatted.concat "<p>"+s+"</p>" }

    # d = desc.split("<br>").reject { |str| str.stip.empty? }
    # d.inject("") { | formatted_s, s |  formatted_s.concat "<p>"+s+"</p>" }

    formatted
  end

  def scrape_callout
    @callout
  end

  def scrape_subtitle # country, year
    title_text = scrape_title
    doc.css(PfaEvent::SUBTITLE).text.sub(title_text, '').strip
  end

  def scrape_times
    Time.zone = VenueScraper::PACIFIC_TIME_ZONE
    t = scrape_time_text
    d = scrape_date_text

    if d.empty? then d = scrape_date_no_img end
    Time.zone.parse("#{d}, #{t}")
  end

  def scrape_stills
    s = doc.css( PfaEvent::IMG )

    st = s.map do |img|
      ScrapedStill.new do |s|
        s.url = CGI.unescapeHTML( img.attr('src').strip )
        s.alt = img.attr('alt').strip
      end
    end

    stills = st unless st.empty?
  end
end