module Scrape
  module Logging
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

    include ActiveSupport::TaggedLogging
    attr_accessor :logger, :log_tags, :log_io

    def initialize
      @log_io = MyIO.new('log/scrape.log')
      @logger = ActiveSupport::TaggedLogging.new(Logger.new(log_io, shift_age='weekly'))
      @log_tags = [:timestamp, :association_tag, :record_class]

      # io.file = 'log/scrape.log'
    end

    # def add_log_tag

    # end

    def timestamp
      Time.now.to_formatted_s(:short)
    end

    def record_class
      record.class
    end

    def association_tag
      venue_tag || belongs_to_tag
    end

    def venue_tag
      venue_name(record)
    end

    def venue_name(r)
      if r.respond_to?(:venue) && r.venue
        r.venue.abbreviation || r.venue.name
      end
    end

    def test
      log_io.file = 'log/test_scrape.log'
      nil
    end

    def belongs_to_tag
      message = nil
      unless record.respond_to?(:venue)
        record.reflections.each do |name, reflection|
          if reflection.macro == :belongs_to
            a = record.send(name)
            if a then message = "#{venue_name(a)} #{a.class} #{a.id}" end
          end
        end
      end
      message
    end

    def make_tags(array)
      array.map { |t|
        if t.is_a? String
          t
        elsif t.is_a? Symbol
          send(t)
        end # could support procs or something, not necessary now.
      }.compact # <-- specifically to filter out nil tags that might depend on block
    end

    def add_log(log_level, message, *more_tags)
      tag_instructions = more_tags ? log_tags.concat(more_tags) : log_tags # does this change the instance variable? I don't think so. Just the returned value from my accessor
      tags = make_tags(tag_instructions)
      log_tags.pop( more_tags.length )

      log_level = :info unless [:unknown, :fatal, :error, :warn, :info, :debug].include? log_level
      logger.tagged(*tags) { logger.send(log_level, message) }
    end

    def with_logging(log_level, message, *more_tags)
      log_level_before, log_level_after = log_level.is_a?(Array) ? [log_level[0], log_level[1]] : log_level

      begin
        add_log( log_level_before, 'Starting ' + message, *more_tags )
        yield self
        add_log( log_level_after,  'Finished ' + message, *more_tags )
      rescue
        add_log( :error, 'Could not complete ' + message, *more_tags )
        raise
      end
    end
  end
end