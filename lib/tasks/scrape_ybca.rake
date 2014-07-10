require 'open-uri'
require 'uri'

namespace :scrape do
  desc "scrape ybca with nokogiri"
  task ybca: :environment do
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

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
    EVENT_IMAGE = ".views-field-field-event-image-fid img"
    EVENT_THUMB = ".imagecache-listing_mini_default"
    EVENT_TITLE = ".event-title span"
    EVENT_TIME = ".views-field-field-event-date-value"
    EVENT_LOC = ".views-field-field-event-venue-nid"
    EVENT_DESCR = ".event-description"
    EVENT_ADMISSION = ".event-admission"
    EVENT_TICKETS = ".buy-ticket-link a"
    EVENT_URL_SUFFIX = "#related_events"
    EVENT_SHOW_NOTES_CREDITS = "p:nth-child(1) strong"

    # general purpose constants
    TIME_ZONE = 'Pacific Time (US & Canada)'
    STYLE_TAGS = %w{i b}

    def remove_empty_tags( html_string )
      re = /<(.+?)>(\n)*(<br>)*(\n)*<\/\1>/m
      subbed = html_string.gsub(re, "")
      if re.match subbed
        remove_empty_tags(subbed)
      else
        return subbed
      end
    end

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
        title: doc.css(SERIES_TITLE).text.slice(/(.+)\|/, 1).strip
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

    # get events
    series_objects.each do |series|
      doc = Nokogiri::HTML(open(series[:url]))
      doc = fix_links(doc, series[:url])
      events = doc.css(".event-inner-inner") # an array of event nodes
      events_arr = []

      events.each_with_index do |event, i|        
        Time.zone = TIME_ZONE
        #############################
        ################### "FIRST" because I don't know if I want
        # to split it into separate events, change TIME to array, etc.
        time = Time.zone.parse(event.css(EVENT_TIME).children.first.text)

        show_notes = show_credits = nil
        show_chunk = event.css(EVENT_SHOW_NOTES_CREDITS).inner_html

        # Extracting Notes and Credits from Description
        if show_chunk.empty?
        # Check for credits + notes
        elsif matches = /(By.+?)<br>(.+)/m.match(show_chunk)
          show_credits = matches[1]
          show_notes = matches[2]
        # just the credits
        elsif matches = /(By.+)/.match(show_chunk)
          show_credits = matches[1]
        else
          show_notes = show_chunk
        end

        # Cleaning up Description
        description = event.css(EVENT_DESCR).inner_html.strip

        [show_notes, show_credits].each do |s|
          if s
            description.sub!(s, "")
            s.strip
          end
        end

        description = remove_empty_tags(description)
        description.strip!

        if matches = /\A(<p>)*<br>(.+)/m.match(description)
          # if <p> doesn't find a match, matches[2] will be nil
          description = matches[1] + matches[2].to_s
        end

        puts event.css(EVENT_TITLE).text.strip
        puts show_notes

        e = {
          title: event.css(EVENT_TITLE).text.strip,
          description: description,
          time: time,
          series_id: [series[:id]], #for now it needs this, some issue with the many-to-many or the name
          url: series[:url] + EVENT_URL_SUFFIX,
          location_notes: event.css(EVENT_LOC).inner_html,
          show_credits: show_credits,
          show_notes: show_notes,
          admission: event.css(EVENT_ADMISSION).inner_html.strip,
          still: event.css(EVENT_THUMB).attr("src").inner_html
        }
        
        events_arr[i] = e
      end

      event_objects.concat events_arr
    end

    # create events
    event_objects.each do |event|
      v = Venue.find_or_create_by(name: "Yerba Buena Center for the Arts")
      s = Series.find(event[:series_id])
      e = Event.new(
        venue: v,
        series: s, # didn't work; wants a series, not an array here
        title: event[:title],
        description: event[:description],
        time: event[:time],
        location_notes: event[:location_notes],
        show_credits: event[:show_credits],
        show_notes: event[:show_notes],
        admission: event[:admission],
        still: event[:still])
      # e.series << [s]

      # write a method on the class specifically for scrapers, where I pass in e.g. "YBCA", or maybe the venue object

      Event.save_scraped_record(e, :series)
    end

    Venue.find_by(name: "Yerba Buena Center for the Arts").update_attributes(abbreviation: "YBCA")
  end
end