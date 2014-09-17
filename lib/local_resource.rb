# cf http://viget.com/extend/make-remote-files-local-with-ruby-tempfile

require 'open-uri'
class LocalResource
  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def file
    @file ||= Tempfile.new(tmp_filename, tmp_folder, encoding: encoding).tap do |f|
      io.rewind
      f.write(io.read)
      f.close
    end
  end

  def io
    if uri.respond_to?(:open)
      @io ||= uri.open
    elsif uri.respond_to?(:path)
      @io ||= open(uri.path)
    end
  end

  def encoding
    io.rewind
    io.read.encoding
  end

  def tmp_filename
    [
      Pathname.new(uri.path).basename,
      Pathname.new(uri.path).extname
    ]
  end

  def tmp_folder
    Rails.root.join('tmp')
  end

  def self.file_from_uri(uri)
    LocalResource.new(uri).file
  end

  def self.file_from_url(url)
    LocalResource.new(URI.parse(url)).file
  end

  def self.with_file_from_url(url)
    f = LocalResource.new(URI.parse(url)).file
    begin
      yield f
    ensure
      f.close
      f.unlink
    end
  end
end