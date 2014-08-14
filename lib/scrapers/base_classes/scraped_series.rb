class ScrapedSeries
  include Scrape
  attr_reader :url, :doc, :title, :description

  def initialize(url)
    @url = url
    @doc = make_doc url
  end

  # defined on VenueScraper too...
  def urls(selector)
    find_urls doc, selector
  end

  def method_missing(*args)
    # use Series.column_names or a hand list to return nil on undefined attribute methods
  end
end