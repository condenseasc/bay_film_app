require 'scrape/logging'
require 'compare'
require 'local_resource'

module Scrape
  module Saving

    def self.extended(klass)
      klass.include Scrape::Logging
      klass.include Compare::Records
      # klass.include Saving::Stills
    end

    module Stills
      def save_stills
        if record && stills && !stills.empty? 
          stills.each { |s| s.build_record; s.save_still_to(record) }
        end
      end
    end

# def save_or_update_with_identity_on(identifying_attribute, *identity_scope, query:nil)
  # if query
  #   match_query = query
  # else
  #   match_query = ->(x, attr_list){ x.class.where( attr_list.map { |i| [i.to_sym, x.send(i)] }.to_h ) }
  # end

# -> (x) { joins(:events).where(events: { time: x.time, venue: x.venue }, title: x.title ) }

    def save_or_update_using_identity_attributes(identifying_attribute, *identity_scope)
      identity_conditions = [identifying_attribute].concat identity_scope
      match_query = ->(x, attr_list){ x.class.where( attr_list.map { |i| [i.to_sym, x.send(i)] }.to_h ) }

      send :define_method, :save_record do
        
        if record.nil?
          scrape
          sleep 1
        end

        if record.nil?
          return
        elsif
          record.persisted? && !record.changed?
          return record
        end

        if record.valid?
          with_logging([:debug, :info], "Save new #{identifying_attribute.to_s}:#{record.send(identifying_attribute)}", :id) { record.save! }
          record
        elsif record.errors.size == 1 && record.errors[identifying_attribute][0] == "exists in scope #{identity_scope}"
          persisted_records = match_query.call(record, identity_conditions)

          if persisted_records.length > 1
            add_log(:error, "Duplicates #{persisted_records.map(&:id)} found for id:#{record.class} #{record.id} by #{identifying_attribute} in #{identity_conditions}")
            raise DuplicateRecordError.new, "#{record.class} id:#{record.id}"
          else
            persisted = persisted_records[0]
          end

          attributes = attribute_difference_from(persisted)

          if attributes
            with_logging([:debug, :info], "Update #{persisted.id}:#{persisted.send(identifying_attribute)} -> #{attributes.inspect}") { persisted.update!(attributes) }
            persisted
          else
            add_log(:debug, "Identical to #{persisted.id}:#{persisted.send(identifying_attribute)}")
            persisted
          end
        else
          add_log(:error, "Validation errors. ERRORS: #{record.errors.messages} OBJECT: #{record.inspect} ")
          nil
        end
      end
    end
  end
end