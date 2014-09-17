require 'open-uri'

module Scrape
  class NokoDoc
    extend Forwardable

    @nokogiri_html_document_methods = Nokogiri::HTML::Document.instance_methods.select do |m|
      relation = Nokogiri::XML::Node <=> Nokogiri::HTML::Document.instance_method(m).owner
      relation == 0 || relation == 1
    end

    attr_accessor :doc_url, :doc_path, :noko_doc

    def initialize(url, path: nil)
      @doc_url = url
      @doc_path = path
      @noko_doc = Nokogiri::HTML::Document.new
    end

    def_delegators :@noko_doc, *@nokogiri_html_document_methods

    def open_doc
      if doc_path
        @noko_doc = Nokogiri::HTML( open doc_path )
      else
        @noko_doc = Nokogiri::HTML( open doc_url )
      end

      fix_links
      self
    end

    # converts all links in a document to absolute links
    def fix_links
      noko_doc.traverse {|node| fix_node_link( node ) }
    end

    def fix_node_link( node )
      if node.name === 'a' && node.attr('href')
        fixed = to_absolute_url( URI.encode(node.attr('href')))
        node.set_attribute('href', fixed)
      elsif node.name === 'img' && node.attr('src')
        fixed = to_absolute_url( URI.encode(node.attr('src')))
        node.set_attribute('src', fixed)
      end
    end

    def to_absolute_url( href )
      if (URI(href).relative?)
       URI.join( doc_url, href ).to_s
      else
       href
      end
    end

    def find_urls( selector )
      noko_doc.css( selector ).map { |node| node['href'] }
    end

    # def urls_must_contain( arr, str )
    #   regex = Regexp::new(str)
    #   arr.delete_if { |l| l !~ regex }
    # end

    def remove_empty_tags( html_string )
      re = /<(.+?)>(\n)*(<br>)*(\n)*<\/\1>/m
      subbed = html_string.gsub re, ''
      
      if re.match subbed
        remove_empty_tags(subbed)
      else
        return subbed
      end
    end

    #   if uri.is_a? URI::HTTP
    #     @noko_doc = Nokogiri::HTML( open uri )
    #   elsif uri.is_a? URI::Generic
    #     @noko_doc = Nokogiri::HTML( open path )
    #   end
  end
end