require 'scrape/pfa/pfa_scraper'

class PfaEvent < ScrapedEvent
  class << self
    attr_reader :venue
  end
  @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)

  ###

  def initialize(url, series:nil, path:nil)
    super
    @venue = PfaEvent.venue
  end

  ###

  def scrape_title
    doc.css(PfaScraper::EVENT_TITLE).text
  end

  def scrape_description
    wrapper = doc.css( ".sub_wrapper" ).inner_html
    if /ldheader/.match(wrapper)
      desc = wrapper.partition(/<div.+class=.*"ldheader">.*<\/div>/m)[2]
      # should set show_notes on Event
      self.announcement = @announcement = doc.css(".ldheader").inner_html.strip
    else
      desc = doc.css( PfaScraper::EVENT_TEXT_BLOB ).inner_html
      desc = desc.gsub /<\/?p>/, '' # <p> just wraps the text
    end
    # format description with <p> tags instead of <br>
    formatted = ""
    d = desc.split "<br>"
    d.reject! { |string| string.strip.empty? }
    d.each { |s| formatted.concat "<p>"+s+"</p>" }
    formatted
  end

  def scrape_announcement
    @announcement
  end

  def scrape_short_credit
    title_text = doc.css(PfaScraper::EVENT_TITLE).text
    doc.css(PfaScraper::EVENT_SHORT_CREDIT).text.sub(title_text, '').strip
  end

  def scrape_time
    Time.zone = VenueScraper::PACIFIC_TIME_ZONE
    t = doc.css( PfaScraper::EVENT_TIME ).text
    d = doc.css( PfaScraper::EVENT_DATE ).text
    if d.empty? then d = doc.css( PfaScraper::EVENT_DATE_NO_IMG ).text end
    Time.zone.parse("#{d}, #{t}")
  end

  def scrape_stills
    s = doc.css( PfaScraper::EVENT_IMG )

    st = s.map do |img|
      ScrapedStill.new do |s|
        s.url = CGI.unescapeHTML( img.attr('src').strip )
        s.alt = img.attr('alt').strip
      end
    end

    stills = st unless st.empty?
  end
end