module Compare
  module Records
    EVENT_EXCLUSIONS = %w{id time title venue created_at updated_at still}
    IMAGE_EXCLUSIONS = %w{}
    SERIES_EXCLUSIONS = %w{}
    
    # Is this any better than just overwriting the old record?
    # Well, it only gives positive differences, i.e. only non empty values can count as a 'difference'
    def attribute_difference(persisted_record, new_record, excluded_list)
      updated_attr_hash = {}
      # excluded = %w{id time title venue created_at updated_at still}
      updated_keys = new_record.attributes.keys.delete_if do |a|
        excluded_list.any? { |x| a.match(x) } || persisted_record["#{a}"] === new_record["#{a}"]
      end

      updated_keys.each { |a| updated_attr_hash["#{a}".to_sym] = new_record["#{a}"] }
      updated_attr_hash
    end

    # Takes relations (not records) and returns the difference as an array of records
    def association_difference(persisted_relation, new_relation)
      new_relation.to_a.delete_if do |n|
        persisted_relation.any? { |p| p.id == n.id }
      end
    end
  end

  module Images
    def duplicate?(image1_filename, image2_filename)
      img1 = Phashion::Image.new image1_filename
      img2 = Phashion::Image.new image2_filename

      img1.duplicate? img2
    end
  end
end