require 'open-uri'
require 'uri'

namespace :scrape do
  desc "scrape pfa with nokogiri"
  task pfa: :environment do
    # some variables
    PFA_URL = "http://www.bampfa.berkeley.edu/filmseries/"
    TIME_ZONE = 'Pacific Time (US & Canada)'
    PERMITTED_STYLE_TAGS = %w{i b}
    # Main Page Selectors
    PFA_SERIES_CSS = ".textblack a"
    # Series Selectors
    SERIES_TITLE = "h2"
    SERIES_DESCRIPTION = "p:nth-child(6)" #insanely, selectorgadget says 7
    EVENT = "p a"
    # Event Selectors
    EVENT_TITLE = "#sub_maintext span"
    EVENT_DATE = ".sub_wrapper div:nth-child(3)"
    EVENT_TIME = ".sub_wrapper tr:nth-child(1) td:nth-child(1)"
    EVENT_BLURB = ".sub_wrapper p"

    # We'll construct arrays of hashes and then put them all in the db later
    series_objects = []
    event_objects = []

    series_urls = find_links( PFA_URL, PFA_SERIES_CSS)
    series_urls.delete_if { |url| url !~ %r'/filmseries/' }

    # Construct an array of hashes defining series
    series_urls.each_with_index do | series_url, i |
      doc = Nokogiri::HTML(open( series_url ))
      doc = fix_links(doc, series_url)
      title = doc.css( SERIES_TITLE ).text
      descr = doc.css( SERIES_DESCRIPTION )

      descr = descr.inner_html

      series_objects[i] = { title: title, description: descr, url: series_url }
    end

    # create series
    series_objects.each do |series|
      s = Series.create!(
        title: series[:title],
        description: series[:description],
        url: series[:url])
      series[:id] = s.id
    end

    # Get those events
    series_objects.each do |series|
      arr = find_links( series[:url], EVENT )
      arr.delete_if { |url| url !~ %r'/film/' }
      events = []
      # make array of event hashes from array of urls, then append
      arr.each_with_index do |event_url, i| 
        events[i] = {url: event_url, series: series[:id]}
      end
      event_objects.concat events
    end

    event_objects.each_with_index do | event, i |
      doc = Nokogiri::HTML(open( event[:url] ))
      doc = fix_links(doc, event[:url])

      date = doc.css( EVENT_DATE ).text
      time = doc.css( EVENT_TIME ).text
      Time.zone = TIME_ZONE
      event[:time] = Time.zone.parse("#{date}, #{time}")
      event[:title] = doc.css( EVENT_TITLE ).text
      event[:description] = doc.css( EVENT_BLURB ).inner_html
    end

    # create events
    event_objects.each do |event|
      v = Venue.find_or_create_by(name: "Pacific Film Archive")
      s = Series.find(event[:series])
      v.events.create!( 
        title: event[:title], 
        time: event[:time], 
        description: event[:description],
        series: s)
    end
  end

  # Task Methods
  def to_absolute_url( page_url, href )
    if (URI(href).relative?)
     URI.join( page_url, href ).to_s
    else
     href
    end
  end

  # converts all links in a document to absolute links
  def fix_links( noko_doc, page_url )
    noko_doc.traverse {|node| fix_node_link(node, page_url) }
    return noko_doc
  end

  def fix_node_link( node, page_url )
    if node.name === "a" && node.attr("href")
      fixed = to_absolute_url(page_url, node.attr("href"))
      node.set_attribute("href", fixed)
    end
  end

  def find_links( page_url, css )
    doc = Nokogiri::HTML(open( page_url ))
    # doc = fix_links(doc, page_url)
    nodes = doc.css( css )
    nodes.map { |node| to_absolute_url( page_url, node['href'] )}
  end

  def urls_must_contain( arr, str )
    regex = Regexp::new(str)
    arr.delete_if { |l| l !~ regex }
  end
end