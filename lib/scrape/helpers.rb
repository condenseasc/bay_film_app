module Scrape
  module Helpers
    def scrape_text(*args)
      args.each do |attr|
        define_method "scrape_#{attr.to_s}" do
          doc.css( Kernel.const_get( "#{self.class.to_s}::#{attr.to_s.upcase}" ) ).text.strip
        end
      end
    end

    def scrape_inner_html(*args)
      args.each do |attr|
        define_method "scrape_#{attr.to_s}" do
          doc.css( Kernel.const_get( "#{self.class.to_s}::#{attr.to_s.upcase}" ) ).inner_html.strip
        end
      end
    end
  end
end