class ScrapedEvent
  include Scrape
  attr_reader :url, :doc, :node, :title, :description, :show_notes, :show_credits, :admission, :location_notes, :still

  # Taking care only of the simplest case. Overwrite otherwise
  def initialize(url)
    @url = url
    @doc = make_doc url
  end

  def method_missing(*args)
    # use Event.column_names or a hand list to return nil on undefined attribute methods
  end
end