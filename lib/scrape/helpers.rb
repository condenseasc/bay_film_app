module Scrape
  module Helpers
    module CSS
      def fetch_css(attr)
        Kernel.const_get( "#{self.class.to_s}::#{attr.to_s.upcase}" )
      end
    end

    def self.extended(base)
      base.include Scrape::Helpers::CSS
    end


    def scrape_text(*args)
      args.each do |attr|
        define_method "scrape_#{attr.to_s}" do
          doc.css( fetch_css(attr) ).text.strip
        end
      end
    end

    def scrape_inner_html(*args)
      args.each do |attr|
        define_method "scrape_#{attr.to_s}" do
          doc.css( fetch_css(attr) ).inner_html.strip
        end
      end
    end

    def use_scrape_images
      define_method "scrape_images" do
        doc.css( fetch_css(:images) ).map do |img|
          _alt    = img.attr('alt')
          _title  = img.attr('title')

          ImageScraper.new do |s|
            s.source_url = CGI.unescapeHTML( img.attr('src').strip )
            s.alt        = _alt.strip   if _alt
            s.title      = _title.strip if _title
          end
        end
      end
    end
  end
end