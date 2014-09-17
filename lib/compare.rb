module Compare
  module Records
    EVENT_EXCLUSIONS = %w{id time title venue created_at updated_at stills}
    STILL_EXCLUSIONS = %w{id event_id image_file_name image_content_type image_file_size image_updated_at }
    SERIES_EXCLUSIONS = %w{id events stills venue created_at updated_at }
    
    # Is this any better than just overwriting the old record?
    # Well, it only gives positive differences, i.e. only non empty values can count as a 'difference'

    # Called on any ScrapedX class, takes a regular ActiveRecord record for comparison
    def attribute_difference_from(reference_record)
      excluded_list = Kernel.const_get('Compare::Records::'+ record.class.to_s.upcase + "_EXCLUSIONS")
      diff_record = record
      Compare::Records._attr_diff(reference_record, diff_record, excluded_list)
    end

    def self.attribute_difference_between(reference_record, diff_record)
      excluded_list = Kernel.const_get('Compare::Records::'+ reference_record.class.to_s.upcase + "_EXCLUSIONS")
      Compare::Records._attr_diff(reference_record, diff_record, excluded_list)
    end

    # returns hash of non-nil differences between records
    def self._attr_diff(reference_record, diff_record, excluded_list)
      updated_keys = diff_record.attributes.keys.delete_if do |a|
        excluded_list.any? { |x| a.match(x) } || 
        diff_record[a] == nil                 || # not 100% sure this is best. if a record is changed as a whole, keeping fields may be counterproductive
        diff_record[a] == reference_record[a]
      end

      updated_attr_hash = {}
      updated_keys.each { |a| updated_attr_hash[a.to_sym] = diff_record[a] }
      if updated_attr_hash.empty? then nil else updated_attr_hash end
    end

    # Takes relations (not records) and returns the difference as an array of records
    def self.association_difference(persisted_relation, new_relation)
      new_relation.to_a.delete_if do |n|
        persisted_relation.any? { |p| p.id == n.id }
      end
    end
  end

  module Images
    def self.duplicate?(image1_filename, image2_filename)
      img1 = Phashion::Image.new image1_filename
      img2 = Phashion::Image.new image2_filename

      img1.duplicate? img2
    end
  end
end