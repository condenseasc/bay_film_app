
module Scrape
  class MyIO
    def initialize(filename = nil)
      @file = File.open(filename, 'a+')
    end

    def file=(filename)
      @file = File.open(filename, 'a+')
    end

    def write(data)
      @file.write(data) if @file
    end

    def close
      @file.close if @file
    end
  end
end

class Scrape::Logger
  def initialize(*tags)
    @log_io = Scrape::MyIO.new('log/scrape.log')
    @logger = ActiveSupport::TaggedLogging.new(Logger.new(log_io, shift_age='weekly'))
    @log_tags = [:timestamp, :association_tag, :subject_class].concat tags.flatten if tags
  end

  attr_accessor :log_io, :logger, :log_tags, :subject

  def write(log_level, message, *more_tags, subject:nil)
    @subject = subject

    tag_instructions = more_tags ? log_tags.concat(more_tags) : log_tags
    tags = make_tags(tag_instructions)
    log_tags.pop( more_tags.length )

    log_level = :info unless [:unknown, :fatal, :error, :warn, :info, :debug].include? log_level

    logger.tagged(*tags) { logger.send(log_level, message) }

    @subject = nil
  end

  def with_logging(log_level, message, *more_tags, subject:nil)
    log_level_before, log_level_after = log_level.is_a?(Array) ? [log_level[0], log_level[1]] : log_level

    begin
      write( log_level_before, "Starting  #{message}", *more_tags, subject:subject)
      result = yield
      write( log_level_after, "Finished #{message} with result #{result}", *more_tags,  subject:subject )
      result
    rescue
      write( :error, "Could not complete #{message}", *more_tags, subject:subject )
      raise
    end
  end

  def make_tags(array)
    array.map { |t|
      if t.is_a? String
        t
      elsif t.is_a? Symbol
        send(t)
      end # could support procs or something, not necessary now.
    }.compact # <-- filter out nil tags that might depend on block
  end

  def belongs_to_tag
    reflecs = Array subject.reflections.select { |k,v| v.macro == :belongs_to }
    records = reflecs.map { |ref| subject.send(ref[0])}.compact

    records.inject("belongs_to:") do |memo, obj|
      memo += " #{obj.class}:#{obj.id}"
    end unless records.empty?
  end

  def timestamp
    Time.now.to_formatted_s(:short)
  end

  def subject_class
    subject.class
  end

  def subject_id
    subject.id
  end

  def association_tag
    venue_tag || belongs_to_tag || nil
  end

  def venue_tag
    venue_name(subject)
  end

  def venue_name(obj)
    if obj.respond_to?(:venue) && obj.venue
      obj.venue.abbreviation || obj.venue.name
    end
  end

  def test
    self.log_io.file = 'log/test_scrape.log'
    nil
  end
end

#   module Logging
#     class MyIO
#       def initialize(filename = nil)
#         @file = File.open(filename, 'a+')
#       end

#       def file=(filename)
#         @file = File.open(filename, 'a+')
#       end

#       def write(data)
#         @file.write(data) if @file
#       end

#       def close
#         @file.close if @file
#       end
#     end

#     include ActiveSupport::TaggedLogging
#     attr_accessor :logger, :log_tags, :log_io

#     def initialize
#       @log_io = MyIO.new('log/scrape.log')
#       @logger = ActiveSupport::TaggedLogging.new(Logger.new(log_io, shift_age='weekly'))
#       @log_tags = [:timestamp, :association_tag, :record_class]

#       # io.file = 'log/scrape.log'
#     end

#     # def add_log_tag

#     # end

#     def timestamp
#       Time.now.to_formatted_s(:short)
#     end

#     def record_class
#       record.class
#     end

#     def record_id
#       record.id
#     end

#     def association_tag
#       venue_tag || belongs_to_tag
#     end

#     def venue_tag
#       venue_name(record)
#     end

#     def venue_name(r)
#       if r.respond_to?(:venue) && r.venue
#         r.venue.abbreviation || r.venue.name
#       end
#     end

#     def test
#       log_io.file = 'log/test_scrape.log'
#       nil
#     end

#     def belongs_to_tag
#       message = nil
#       unless record.respond_to?(:venue)
#         record.reflections.each do |name, reflection|
#           if reflection.macro == :belongs_to
#             a = record.send(name)
#             if a then message = "#{venue_name(a)} #{a.class} #{a.id}" end
#           end
#         end
#       end
#       message
#     end

#     def make_tags(array)
#       array.map { |t|
#         if t.is_a? String
#           t
#         elsif t.is_a? Symbol
#           send(t)
#         end # could support procs or something, not necessary now.
#       }.compact # <-- specifically to filter out nil tags that might depend on block
#     end

#     def add_log(log_level, message, *more_tags)
#       tags = make_tags(tag_instructions)
#       tag_instructions = more_tags ? log_tags.concat(more_tags) : log_tags 
#       log_tags.pop( more_tags.length )

#       log_level = :info unless [:unknown, :fatal, :error, :warn, :info, :debug].include? log_level
#       logger.tagged(*tags) { logger.send(log_level, message) }
#     end

#     def with_logging(log_level, message, *more_tags)
#       log_level_before, log_level_after = log_level.is_a?(Array) ? [log_level[0], log_level[1]] : log_level

#       begin
#         add_log( log_level_before, 'Starting ' + message, *more_tags )
#         yield self
#         add_log( log_level_after,  'Finished ' + message, *more_tags )
#       rescue
#         add_log( :error, 'Could not complete ' + message, *more_tags )
#         raise
#       end
#     end
#   end
# end