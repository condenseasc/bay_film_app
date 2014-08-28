module Scrape
  require 'open-uri'

  def to_absolute_url( page_url, href )
    if (URI(href).relative?)
     URI.join( page_url, href ).to_s
    else
     href
    end
  end

  # converts all links in a document to absolute links
  def fix_links( nokogiri_document, page_url )
    nokogiri_document.traverse {|node| fix_node_link(node, page_url) }
    return nokogiri_document
  end

  def fix_node_link( node, page_url )
    if node.name === 'a' && node.attr('href')
      fixed = to_absolute_url(page_url, URI.encode(node.attr('href')))
      node.set_attribute('href', fixed)
    elsif node.name === 'img' && node.attr('src')
      fixed = to_absolute_url(page_url, URI.encode(node.attr('src')))
      node.set_attribute('src', fixed)
    end
  end

  # Returns an array of urls, no longer converted to absolute
  def find_urls( nokogiri_document, selector )
    nokogiri_document.css( selector ).map { |node| node['href'] }
  end

  def urls_must_contain( arr, str )
    regex = Regexp::new(str)
    arr.delete_if { |l| l !~ regex }
  end

  def remove_empty_tags( html_string )
    re = /<(.+?)>(\n)*(<br>)*(\n)*<\/\1>/m
    subbed = html_string.gsub re, ''
    
    if re.match subbed
      remove_empty_tags(subbed)
    else
      return subbed
    end
  end

  def make_doc(url)
    fix_links( Nokogiri::HTML( open url ), url )
  end

  def make_doc_from_file(path, url)
    fix_links( Nokogiri::HTML( open path ), url )
  end
end