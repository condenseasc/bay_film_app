module ScrapedStills

  # takes an array of Still objects
  def save_scraped_stills(scraped_stills)
    persisted_stills = stills.to_a
    # if no stills, no more tests necessary, all new stills are valid
    if persisted_stills.empty?
      stills << scraped_stills
    else
      scraped_stills.each do |scraped|
        match = false
        persisted_stills.each do |persisted|
          if Compare::Images.duplicate?(persisted.image.path, scraped.image.path) &&
            scraped.image.size > persisted.image.size
            match = true
            persisted.image = scraped.image
          end
        end
        stills << scraped unless match
      end
    end
    save
  end
end