# require 'scrape/base/scraped_still'
require 'spec_helper'

require 'scrape/base/venue_scraper'
require 'local_resource'
require 'compare'


RSpec.describe ScrapedStill do

  def still_with_test_logs
    s = still
    s.log_tags = ['scraped_still_spec', :timestamp, :test]
    s
  end

  def still
    ScrapedStill.new( uri_smaller, alt:'test')
  end

  let(:filename_smaller) { 'example_smaller_scraped_still.jpg' }

  let(:path_smaller) { Rails.root.join('spec', 'scrapers', 'base', 'example_smaller_scraped_still.jpg') }
  let(:path_larger)  { Rails.root.join('spec', 'scrapers', 'base', 'example_larger_scraped_still.jpg') }
  let(:saved_path)   { Rails.root.join('public', 'system', 'stills', 'images') }
  let(:uri_smaller)  { URI.join('file:///', path_smaller.to_s) }
  let(:uri_larger)   { URI.join('file:///', path_larger.to_s) }
  let(:event)        { FactoryGirl.create(:event)}


  # filename_smaller = 'example_smaller_scraped_still.jpg'
  # path_smaller = Rails.root.join('spec', 'scrapers', 'example_smaller_scraped_still.jpg')
  # path_larger = Rails.root.join('spec', 'scrapers', 'example_larger_scraped_still.jpg')
  # saved_path =  Rails.root.join('public', 'system', 'stills', 'images')
  # uri_smaller = URI.join('file:///', path_smaller.to_s)
  # uri_larger = URI.join('file:///', path_larger.to_s )
  # event =  FactoryGirl.create(:event)

  before(:all) do
    class LocalScrapedStill < ScrapedStill
      def initialize(*args)
        super
        # @logger = ActiveSupport::TaggedLogging.new(Logger.new('log/scrape_test.log')).extend(Scrape::Logging)
        @log_tags = ['scraped_still_spec', :timestamp, :test]
      end
    end
  end

  describe 'building Still from ScrapedStill' do
    before(:example) { @still = still_with_test_logs }

    describe '#with_temp_image' do
      it 'pulls image into @temp_image' do
        @still.with_temp_image do |img|
          expect(img.size).to be > 100
        end
      end

      it 'has the expected image file path' do
        @still.with_temp_image do |img|
          expect(img.path).to match(/tmp\/#{filename_smaller}/)
        end
      end
    end

    describe '#save_record_to' do
      context 'with new image' do
        before(:example) { @still = still_with_test_logs; @still.save_still_to(event) }

        it 'saves file to public/system' do
          expect(@still.record.image.path).to match(/#{saved_path}.*/)
        end

        it 'persists the event on scraped still' do
          expect(@still.record.persisted?).to be(true)
        end
      end

      context 'with duplicate image' do
        before(:example) do
          @still = still_with_test_logs.save_still_to(event)

          dup_still = LocalScrapedStill.new(uri_smaller, alt: 'something same-y')
          dup_still.save_still_to(event)
        end

        it 'keeps same id on event' do
          expect(@still.record).to eq(event.stills.first)
        end

        it 'doesnt add any more stills to event' do
          expect(event.stills.length).to eq(1)
        end

        it 'does not make any alteration to the image' do
          expect(event.stills.first.image_updated_at_changed?).to be(false)
        end

        it 'doesnt even change the alt text' do
          expect(@still.record.alt).not_to eq('something same-y')
        end
      end

      context 'updates existing scraped stills because, I think, of inverse_of' do
        before(:example) { @still = still_with_test_logs.save_still_to(event) }

        it 'even stills start small' do
          expect(@still.record.image.size).to be < 72113
        end

        it 'grows up' do
          @larger_still = LocalScrapedStill.new(uri_larger, alt: 'bigger bugger better')
          @larger_still.save_still_to(event)

          expect(@still.record.image.size).not_to be < 72113
        end

      end

      context 'larger image' do
        before(:example) do
          @still = still_with_test_logs.save_still_to(event)

          @larger_still = LocalScrapedStill.new(uri_larger, alt: 'bigger bugger butter')
          @larger_still.save_still_to(event)
        end

        it 'does not add any more stills to event' do
          expect(event.stills.length).to be(1)
        end

        it 'keeps the same id' do
          expect(event.stills.first).to eq(@still.record)
        end

        it 'takes the larger image' do
          expect(@still.record.image.size).to eq(@larger_still.record.image.size)
        end

        it 'still does not update the alt text, because whatever its not clear' do
          expect(event.stills.first.alt).not_to eq('bigger bugger butter')
        end
      end
    end
  end
end