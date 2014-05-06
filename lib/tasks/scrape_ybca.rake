require 'open-uri'
require 'uri'

namespace :scrape do
  desc "scrape ybca with nokogiri"
  task ybca: :environment do
    YBCA_URL = "http://www.ybca.org/upcoming/filmvideo"
    SERIES = ".views-field-field-event-object-nid a"

    # series page
    # or ARTIST_BIO = ".field-field-object-artist-bio p" for all the description paragraphs, especially if .odd gives me too much styling
    OVERVIEW = ".field-field-object-overview p"
    ARTIST_BIO = ".field-field-object-artist-bio p"
    IMAGE_CAROUSEL = ".imagecache-object_carousel_default"
    SERIES_TITLE = "title"

    # events on series page
    EVENT_INNER = ".event-inner-inner"
    # event selectors, inside event-inner
    EVENT_IMAGE = "views-field-field-event-image-fid img"
    EVENT_TITLE = ".event-title span"
    EVENT_TIME = ".views-field-field-event-date-value"
    EVENT_LOC = ".views-field-field-event-venue-nid"
    EVENT_DESCR = ".event-description p"
    EVENT_ADMISSION = ".event-admission"
    EVENT_TICKETS = ".buy-ticket-link a"
    EVENT_URL_SUFFIX = "#related_events"

    # general purpose constants
    TIME_ZONE = 'Pacific Time (US & Canada)'
    STYLE_TAGS = %w{i b}

    series_objects = []
    event_objects = []

    # get series
    series_urls = find_links(YBCA_URL, SERIES)
    series_urls.uniq!

    series_urls.each_with_index do |series_url, i|
      doc = Nokogiri::HTML(open(series_url))
      doc = fix_links(doc, series_url)

      images = []
      doc.css(IMAGE_CAROUSEL).each_with_index do |node, index|
        images[index] = {
          src: node.attr("src"),
          title: node.attr("title") }
      end

      series = {
        description: doc.css(OVERVIEW).inner_html,
        below: doc.css(ARTIST_BIO).inner_html,
        images: images,
        url: series_url,
        title: doc.css(SERIES_TITLE).text
      }

      series_objects[i] = series
    end

    # create series
    series_objects.each do |series|
      s = Series.create!(
        description: series[:description],
        url: series[:url],
        title: series[:title])
      series[:id] = s.id
    end

    # EVENT_IMAGE = "views-field-field-event-image-fid img"
    # EVENT_TITLE = ".event-title span"
    # EVENT_TIME = ".views-field-field-event-date-value"
    # EVENT_LOC = ".views-field-field-event-venue-nid"
    # EVENT_DESCR = ".event-description p"
    # EVENT_ADMISSION = ".event-admission"
    # EVENT_TICKETS = ".buy-ticket-link a"


    # get events
    series_objects.each do |series|
      doc = Nokogiri::HTML(open(series[:url]))
      doc = fix_links(doc, series[:url])
      events = doc.css(".event-inner-inner") # an array of event nodes
      events_arr = []

      events.each_with_index do |event, i|

        # descr = ""
        # event.css(EVENT_DESCR).each {|node| descr += "<p>#{node.inner_html}</p>"}
        
        Time.zone = TIME_ZONE
        #############################
        ################### "FIRST" because I don't know if I want
        # to split it into separate events, change TIME to array, etc.
        time = Time.zone.parse(event.css(EVENT_TIME).children.first.text)

        e = {
          title: event.css(EVENT_TITLE).text,
          description: event.css(EVENT_DESCR).inner_html,
          time: time,
          series_id: series[:id],
          url: series[:url] + EVENT_URL_SUFFIX
        }
        
        events_arr[i] = e
      end

      event_objects.concat events_arr
    end

    # create events
    event_objects.each do |event|
      v = Venue.find_or_create_by(name: "Yerba Buena Center for the Arts")
      s = Series.find(event[:series_id])
      Event.create!(
        venue: v,
        series: s,
        title: event[:title],
        description: event[:description],
        time: event[:time])
    end
  end
end