require 'open-uri'
require 'uri'


# namespace :scrape
#   desc "scrape pfa by series"
#   task pfa: :environment do
#     series_titles = get_series_titles( PFA_PATH, PFA_SERIES_CSS )
#     series_titles.each do
#       get_movie_
#   end


# # Uses Nokogiri to grab series titles
# def get_series_titles(target_path, series_css)
#   doc = Nokogiri::HTML( open( target_path ) )
#   doc.css( series_css ).map { |link| link.content }
# end

# a = Mechanize.new
# a.get( PFA_PATH )

# namespace :scrape do
#   desc "scrape pfa by series"
#   task pfa_mechanize: :environment do
#     PFA_PATH = "http://www.bampfa.berkeley.edu/filmseries/"
#     PFA_SERIES_CSS = ".textblack b" #formerly had it "a b"
#     PFA_MOVIE_CSS = "p a"
#     TIME_ZONE = 'Pacific Time (US & Canada)'


#     agent = Mechanize.new
#     agent.get(PFA_PATH)

#     doc = Nokogiri::HTML(open(PFA_PATH))
#     doc.css(PFA_SERIES_CSS).each do |series_link|

#       agent.get(PFA_PATH)
#       agent.page.link_with(text: series_link.content).click
#       agent.page.search(PFA_MOVIE_CSS).each do |movie_link|

#         ## Running into a scheme error here, have no idea why
#         #  hm, i bet it's cuz I don't renavigate to the same page,
#         #  I end up looking irrelevant links
#         agent.page.link_with(text: movie_link.content).click
        
#         title = agent.page.search("#sub_maintext span").inner_html
#         date = agent.page.search(".sub_wrapper div:nth-child(3)").inner_html
#         time = agent.page.search(".sub_wrapper tr:nth-child(1) td:nth-child(1)").inner_html
#         parsed_date_time = Time.zone.parse("#{date}, #{time} #{TIME_ZONE}")

#         v = Venue.find_or_create_by_name("Pacific Film Archive")
#         v.events.create!( title: title, time: parsed_date_time )
#       end
#     end
#   end

namespace :scrape do
  desc "scrape pfa with nokogiri"
  task pfa: :environment do
    PFA_URL = "http://www.bampfa.berkeley.edu/filmseries/"
    PFA_SERIES_CSS = ".textblack a b"
    PFA_MOVIE_CSS = "p a"
    TIME_ZONE = 'Pacific Time (US & Canada)'
    STYLE_TAGS = %w{i b}


    series_urls = find_links( PFA_URL, PFA_SERIES_CSS, parent = true )
    series_urls.delete_if { |url| url !~ %r'/filmseries/' }

    series_urls.each do | series_url |
      doc = Nokogiri::HTML(open( series_url ))



      # url = series_url
      title = doc.css("h2")

      # series = Series.create!( )

      movie_urls = find_links( series_url, PFA_MOVIE_CSS )
      movie_urls.delete_if { |url| url !~ %r'/film/' }

      movie_urls.each do | movie_url |
        doc = Nokogiri::HTML(open( movie_url ))
        # doc = Nokogiri::HTML(open("")).css(".sub_wrapper")

        url = movie_url

        title = doc.css("#sub_maintext span").text
        date = doc.css(".sub_wrapper div:nth-child(3)").text
        time = doc.css(".sub_wrapper tr:nth-child(1) td:nth-child(1)").text
        parsed_time = Time.zone.parse("#{date}, #{time} #{TIME_ZONE}")

        ########## convoluted description extractor starts here!   
        string = ""
        ar = []
        blurb = doc.css(".sub_wrapper")

        # Make a nice flat array of nodes
        # Blurb has one node, the div.sub_wrapper node
        # Traverse uses recursion, this test avoids repetition 
        # by only selecting ultimate nodes
        blurb.first.traverse do |n|
          if n.children.empty?
            ar.push(n)
          end
        end

        # convert to string, preserving line breaks
        ar.each { |node| string += (node.name == "br") ? "<br>" : node.text }

        
        # Recover accepted styles with find and replace
        STYLE_TAGS.each do |tag|
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
        # array.each { |str| description += "<p>#{str}</p>" }

        array.first

        # trying to get at the first entry
        array.each_with_index do |str, i|
          if (i==0) 
            description += "<p class='subtitle'>#{str}</p>" 
          else
            description += "<p class='blurb'>#{str}</p>"
          end
        end         
                
        v = Venue.find_or_create_by_name("Pacific Film Archive")
        v.events.create!( title: title, time: parsed_time, description: description )
      end
    end
  end

  # call on an href
  # starting to get why this doesn't work - ruby doesn't look up methods for
  # arrays of strings in this file. a method without a direct receiver wouldn't
  # have that problem I guess. so this issue should exist for the REGEX method too
  # It's a weird file, not a class, prevents Ruby from finding these or at least
  # from seeing them as public
  def to_absolute_url( page_url, href )
    URI.join( page_url, href ).to_s
    # self.map { |href| URI.join( page_url, href ).to_s }
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

  # def recursive thiing
  #   node.children
  # end
end


# def find_or_create_series
