class PfaEvent < ScrapedEvent

  class << self
    attr_reader :venue
  end
  @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)

  def initialize(url, series)
    super(url)
    @series = [series]
    @venue = Venue.find_or_create_by(name: PfaScraper::VENUE_NAME)
  end

  def scrape_title
    doc.css(PfaScraper::EVENT_TITLE).text
  end

  def scrape_description
    wrapper = doc.css( ".sub_wrapper" ).inner_html
    if /ldheader/.match(wrapper)
      desc = wrapper.partition(/<div.+class=.*"ldheader">.*<\/div>/m)[2]
      # should set show_notes on Event
      self.show_notes = @show_notes = doc.css(".ldheader").inner_html.strip
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

  def scrape_show_notes
    @show_notes
  end

  def scrape_show_credits
    title_text = doc.css(PfaScraper::EVENT_TITLE).text
    doc.css(PfaScraper::EVENT_SHOW_CREDITS).text.sub(title_text, '').strip
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

    stills = s.map do |img|
      ScrapedStill.new do |s|
        s.url = CGI.unescapeHTML( img.attr('src').strip )
        s.alt = img.attr('alt').strip
      end
    end
  end
end

# load 'lib/scrapers/pfa/pfa_event.rb'
# class LocalPfaEvent < PfaEvent
#   def initialize(path, url, series)
#     @url = url
#     @doc = make_doc_from_file(path, url)
#     @series = series
#     @venue = PfaScraper.venue
#     @logger = VenueScraper.logger
#   end
# end