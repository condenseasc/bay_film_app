require 'open-uri'
require 'addressable/uri'

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

      @absolutize = ->(x){ to_absolute_url( x ) }
      @normalize  = ->(x){ Addressable::URI.parse( x ).normalize.to_s }
    end

    def_delegators :@noko_doc, *@nokogiri_html_document_methods

    def open
      return self if noko_doc.class == Nokogiri::HTML::Document

      openable = doc_path ? doc_path : doc_url
      @noko_doc = Nokogiri::HTML( Kernel.open openable )
      
      map_urls_do( @absolutize, @normalize )
      self
    end

    def map_urls_do(*functions)
      noko_doc.traverse do |node|
        map_node_url( node ) do |url|
          functions.inject(url) { |_url, func| func.call( _url )  }
        end
      end
    end

    # def normalize_urls
    #   map_doc_urls { |url| Addressable::URI.parse( url ).normalize.to_s }
    # end

    # def absolutize_urls
    #   map_doc_urls { |url| to_absolute_url( url ) }
    # end

    def map_doc_urls
      noko_doc.traverse do |node|
        map_node_url( node ) do |url|
          yield url
        end
      end
    end

    def map_node_url( node )
      if node.name == 'a' && node.attr('href')
        fixed = yield node.attr('href')
        node.set_attribute('href', fixed)
      elsif node.name == 'img' && node.attr('src')
        fixed = yield node.attr('src')
        node.set_attribute('src', fixed)
      end
    end

    def to_absolute_url( href )
      URI(href).relative? ? URI.join( doc_url, href ).to_s : href
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
  end
end