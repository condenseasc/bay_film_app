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
    PFA_SERIES_CSS = ".textblack a b"
    # Series Selectors
    SERIES_TITLE = "h2"
    SERIES_DESCRIPTION = "p:nth-child(6)" #insanely, selectorgadget says 7
    EVENT = "p a"
    # Event Selectors
    EVENT_TITLE = "#sub_maintext span"
    EVENT_DATE = ".sub_wrapper div:nth-child(3)"
    EVENT_TIME = ".sub_wrapper tr:nth-child(1) td:nth-child(1)"
    EVENT_BLURB = ".sub_wrapper"

    # We'll construct arrays of hashes and then put them all in the db later
    series_objects = []
    event_objects = []

    series_urls = find_links( PFA_URL, PFA_SERIES_CSS, parent = true )
    series_urls.delete_if { |url| url !~ %r'/filmseries/' }



    # http://www.bampfa.berkeley.edu/filmseries/ray"))


    # Construct an array of hashes defining series
    series_urls.each_with_index do | series_url, i |
      doc = Nokogiri::HTML(open( series_url ))
      title = doc.css( SERIES_TITLE ).text
      descr = doc.css( SERIES_DESCRIPTION )

      # turn relative links to absolute ones
      descr.each do |node|
        if node.name === "a"
          node.content=(to_absolute_url(series_url, node.content))
        end
      end

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

      # make array of event hashes from array of urls, then append
      arr.each_with_index do |event_url, i| 
        events = []
        events[i] = {url: event_url, series: series[:id]}
      end
      event_objects.concat events
    end

    event_objects.each_with_index do | event, i |

      # pfa_description_extractor(url, css)
      doc = Nokogiri::HTML(open( event[:url] ))
      ########## convoluted description extractor starts here!   
      string = ""
      ar = []
      blurb = doc.css( EVENT_BLURB )

      # Make a flat array representation without repetitions by traversing
      # the blurb node's children and selecting only ultimate nodes
      blurb.first.traverse do |n|
        if n.children.empty?
          ar.push(n)
        end
      end

      # convert to string, preserving line breaks
      ar.each { |node| string += (node.name == "br") ? "<br>" : node.text }

      # Recover accepted styles with find and replace
      PERMITTED_STYLE_TAGS.each do |tag|
        styled = blurb.xpath("//#{tag}")
        styled.each do |node|
          string = string.gsub("#{node.text}", "<#{tag}>#{node.text}</#{tag}>")
        end
      end

      # I only want the text below the title, gets rid of time, series, etc.
      string = string.partition(title)[2]

      # Nokogiri parses the html with tons of return characters
      # so we'll use them as general separators
      string = string.gsub("\n", "\r")
      string = string.gsub(/<\/*br *\/*>/, "\r")

      array = string.split("\r")
      # \r all over, lots of empty strings, especially want no leading or tailing empty strings
      array.delete_if { |str| str.empty? }

      # string = array.join("<br>")

      description = ""

      # trying to get at the first entry
      array.each_with_index do |str, index|
        if (index==0) 
          description += "<p class='subtitle'>#{str}</p>" 
        else
          description += "<p class='blurb'>#{str}</p>"
        end
      end

      date = doc.css( EVENT_DATE ).text
      time = doc.css( EVENT_TIME ).text
      event[:time] = Time.zone.parse("#{date}, #{time} #{TIME_ZONE}")
      event[:title] = doc.css( EVENT_TITLE ).text
      event[:description] = description    
    end

    # create events
    event_objects.each do |event|
      v = Venue.find_by("Pacific Film Archive")
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


  def find_links( page_url, css, parent = false )
    doc = Nokogiri::HTML(open( page_url ))
    nodes = doc.css( css )

    if parent
      nodes.map do |node| 
        href = node.parent['href']
        to_absolute_url( page_url, href )
      end
    else
      nodes.map do |node| 
        href = node['href']
        to_absolute_url( page_url, href )
      end
    end
  end

  def urls_must_contain( arr, str )
    regex = Regexp::new(str)
    arr.delete_if { |l| l !~ regex }
  end
end