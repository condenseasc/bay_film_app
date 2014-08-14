# require 'open-uri'
# require 'uri'
# require 'local_resource'
# include Scrape

# namespace :scrape do
#   desc "scrape ybca with nokogiri"
#   task ybca: :environment do

#     logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))


#     YBCA_URL = "http://www.ybca.org/programs/upcoming/film-and-video"

#     # upcoming page
#     SERIES = ".views-field-field-key-program-cluster a"
#     EVENTS = '.views-field-title a'
#     LAST_EVENT_PAGE = '.arrow.last a'

#     # series page
#     SERIES_TITLE = '.pane-content h1'
#     SERIES_SUBTITLE = '.cluster-field-subtitle .pane-content'
#     SERIES_DESCRIPTION = '.body.field'
#     SERIES_STILL = '.program-cluster-hero-450'
#     SERIES_EVENT_LINK = '.views-field-field-mini-program a'







#     # events on event page
#     EVENT_TITLE = '.program-field-main-title'
#     EVENT_IMAGE = '.program-hero-large-970'
#     # EVENT_IMAGE_TEXT = 'alt and title attributes' <----------------<<
#     EVENT_SUPERTITLE = '.field-name-field-supertitle'
#     EVENT_SUBTITLE = '.program-field-subtitle'
#     EVENT_TIME = '.field-wrapper .date-display-single'








#     # or ARTIST_BIO = ".field-field-object-artist-bio p" for all the description paragraphs, especially if .odd gives me too much styling
#     OVERVIEW = ".field-field-object-overview p"
#     ARTIST_BIO = ".field-field-object-artist-bio p"
#     SERIES_TITLE = "title"



#     # EVENT_INNER = ".event-inner-inner"
#     # event selectors, inside event-inner
#     # EVENT_IMAGE = ".views-field-field-event-image-fid img"
#     # EVENT_THUMB = ".imagecache-listing_mini_default"
#     # EVENT_TITLE = ".event-title span"
#     EVENT_TIME = ".views-field-field-event-date-value"
#     EVENT_LOC = ".views-field-field-event-venue-nid"
#     EVENT_DESCR = ".event-description"
#     EVENT_ADMISSION = ".event-admission"
#     EVENT_TICKETS = ".buy-ticket-link a"
#     EVENT_URL_SUFFIX = "#related_events"
#     EVENT_SHOW_NOTES_CREDITS = "p:nth-child(1) strong"

#     # general purpose constants
#     TIME_ZONE = 'Pacific Time (US & Canada)'
#     STYLE_TAGS = %w{i b}


#     # Get all the urls for UPCOMING EVENTS PAGES
#     ######################################################################
#     uri = URI.parse(doc.css(LAST_EVENT_PAGE).attr('href').value)
#     number_of_pages = CGI.parse(uri.query)['page'].pop.to_i
#     uris = [YBCA_URL]

#     (1..number_of_pages).each do |n|
#       uris.push(URI::HTTP.build(host: URI(YBCA_URL).host, path: uri.path, query: {page: n}.to_param).to_s)
#     end
#     ######################################################################

#     series_urls = []
#     event_urls = []





#     # Get EVENT URLS from UPCOMING EVENTS page
#     ######################################################################
#     uris.each do |uri|
#       doc = Nokogiri::HTML(open(uri))
#       doc = fix_links(doc, uri)

#       event_urls.concat find_links(uri, EVENTS)
#     end
#     ######################################################################

#     series_objects = []
#     event_objects = []


#     # Get actual URLS to distinct SERIES
#     ######################################################################
#     uris.each { |u| series_urls.concat find_links(u, SERIES) }
#     series_urls.uniq!
#     ######################################################################



#     # Get EVENT URLS from series pages
#     ######################################################################
#     series_urls.each_with_index do |series_url, i|
#       doc = Nokogiri::HTML(open(series_url))
#       doc = fix_links(doc, series_url)

#       doc.css(EVENTS).each do |event_link|
#         event_urls.push event_link.attr('href')
#       end

#       # images = []
#       # doc.css(IMAGE_CAROUSEL).each_with_index do |node, index|
#       #   images[index] = {
#       #     src: node.attr("src"),
#       #     title: node.attr("title") }
#       # end


#       series = Series.new(
#         series[:doc].

#         )

#       series = {
#         description: doc.css(SERIES_DESCRIPTION).inner_html,
#         # below: doc.css(ARTIST_BIO).inner_html,
#         # images: images,
#         url: series_url,
#         title: doc.css(SERIES_TITLE).text.strip
#       }

#       series_objects[i] = series
#     end

#     # create series
#     series_objects.each do |series|
#       s = Series.create!(
#         description: series[:description],
#         url: series[:url],
#         title: series[:title])
#       series[:id] = s.id
#     end


#     def scrape_page_for_record([urls], *hash_of_methods)
#     end

#     # get events
#     series_objects.each do |series|
#       doc = Nokogiri::HTML(open(series[:url]))
#       doc = fix_links(doc, series[:url])
#       # events = doc.css(SERIES_EVENT_LINK) # an array of event link nodes
#       series_event_urls = to_absolute_url( YBCA_URL, doc.css(SERIES_EVENT_LINK).attr('href') )

#       # delete these from the general event url array, to prevent duplication
#       series_event_urls.each do |s_url|
#         event_urls.delete(s_url) {
#           logger.tagged("YBCA_SCRAPER_INTERNAL", "SERIES_EVENT_LINKS") {
#             logger.info "Unable to find (and delete) #{s_url} in event_urls"
#           }
#         }
#       end

#       events_arr = []

#       events.each_with_index do |event, i|        
#         Time.zone = TIME_ZONE
#         #############################
#         ################### "FIRST" because I don't know if I want
#         # to split it into separate events, change TIME to array, etc.
#         time = Time.zone.parse(event.css(EVENT_TIME).children.first.text)

#         # show_notes = show_credits = nil
#         # show_chunk = event.css(EVENT_SHOW_NOTES_CREDITS).inner_html

#         # # Extracting Notes and Credits from Description
#         # if show_chunk.empty?
#         # # Check for credits + notes
#         # elsif matches = /(By.+?)<br>(.+)/m.match(show_chunk)
#         #   show_credits = matches[1]
#         #   show_notes = matches[2]
#         # # just the credits
#         # elsif matches = /(By.+)/.match(show_chunk)
#         #   show_credits = matches[1]
#         # else
#         #   show_notes = show_chunk
#         # end

#         # # Cleaning up Description
#         # description = event.css(EVENT_DESCR).inner_html.strip

#         # [show_notes, show_credits].each do |s|
#         #   if s
#         #     description.sub!(s, "")
#         #     s.strip
#         #   end
#         # end

#         # description = remove_empty_tags(description)
#         # description.strip!

#         # if matches = /\A(<p>)*<br>(.+)/m.match(description)
#         #   # if <p> doesn't find a match, matches[2] will be nil
#         #   description = matches[1] + matches[2].to_s
#         # end

#         puts event.css(EVENT_TITLE).text.strip
#         puts show_notes

#         e = {
#           title: event.css(EVENT_TITLE).text.strip,
#           description: description,
#           time: time,
#           series_id: [series[:id]], #for now it needs this, some issue with the many-to-many or the name
#           url: series[:url] + EVENT_URL_SUFFIX,
#           location_notes: event.css(EVENT_LOC).inner_html,
#           show_credits: show_credits,
#           show_notes: show_notes,
#           admission: event.css(EVENT_ADMISSION).inner_html.strip,
#           still: event.css(EVENT_THUMB).attr("src").inner_html
#         }
        
#         events_arr[i] = e
#       end

#       event_objects.concat events_arr
#     end

#     # create events
#     event_objects.each do |event|
#       v = Venue.find_or_create_by(name: "Yerba Buena Center for the Arts")
#       s = Series.find(event[:series_id])
#       e = Event.new(
#         venue: v,
#         series: [s], # didn't work; wants a series, not an array here
#         title: event[:title],
#         description: event[:description],
#         time: event[:time],
#         location_notes: event[:location_notes],
#         show_credits: event[:show_credits],
#         show_notes: event[:show_notes],
#         admission: event[:admission])
#         # still: event[:still])

#       persisted_e = Event.save_scraped_record(e, :series)
#       image = LocalResource.local_resource_from_url(event[:still]).file
#       persisted_e.save_still_if_new_or_larger(image)
#     end

#     Venue.find_by(name: "Yerba Buena Center for the Arts").update_attributes(abbreviation: "YBCA")
#   end
# end