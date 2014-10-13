require 'scrape/pfa/pfa_scraper'
require 'scrape/base/topic_scraper'
require 'scrape/helpers'

class PfaTopic < TopicScraper
  extend Scrape::Helpers

  TITLE             = "#sub_maintext span"
  DATE_TEXT         = ".sub_wrapper div:nth-child(3)"
  TIME_TEXT         = ".sub_wrapper tr:nth-child(1) td:nth-child(1)"
  DATE_NO_IMG       = "#sub_maintext div+ div"
  TEXT_BLOB_WRAPPER = ".sub_wrapper"
  TEXT_BLOB         = ".sub_wrapper p"
  TEXT_BLOB_CALLOUT = ".ldheader"
  SUBTITLE          = ".sub_wrapper tr:nth-child(1) td:nth-child(2)" #minus the title
  IMAGES            = ".media img"

  scrape_inner_html :text_blob, :text_blob_callout, :text_blob_wrapper
  scrape_text       :title, :time_text, :date_text, :date_no_img
  use_scrape_images

  def venue
    @venue ||= Venue.find_by(name: 'Pacific Film Archive Theater')
  end

  def scrape_body
    wrapper = scrape_text_blob_wrapper
    if /ldheader/.match(wrapper)
      desc = wrapper.partition(/<div.+class=.*"ldheader">.*<\/div>/m)[2]
      self.callout = @callout = scrape_text_blob_callout
    else
      desc = scrape_text_blob.gsub /<\/?p>/, '' # <p> just wraps the text
    end

    d = desc.split("<br>").reject { |str| str.strip.empty? }
    d.inject("") { | formatted_s, s |  formatted_s.concat "<p>"+s+"</p>" }
  end

  def scrape_callout
    @callout
  end

  def scrape_subtitle # country, year
    title_text = scrape_title
    doc.css(PfaTopic::SUBTITLE).text.sub(title_text, '').strip
  end

  def scrape_times
    Time.zone = 'Pacific Time (US & Canada)'
    t = scrape_time_text
    d = scrape_date_text

    if d.empty? then d = scrape_date_no_img end
    Time.zone.parse("#{d}, #{t}")
  end
end