# cf http://viget.com/extend/make-remote-files-local-with-ruby-tempfile
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
    @io ||= uri.open
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

  def self.local_resource_from_url(url)
    LocalResource.new(URI.parse(url))
  end
end