require 'scrape/base/image_scraper'
require 'spec_helper'

require 'scrape/base/site_scraper'
require 'local_resource'
require 'compare'


RSpec.describe ImageScraper do

  # def image_with_test_logs
  #   s = image
  #   s.log_tags = ['scraped_image_spec', :timestamp, :test]
  #   s
  # end

  # def image
  #   ImageScraper.new( uri_smaller, alt:'test')
  # end

  def new_image_scraper( url=uri_smaller, alt:'test' )
    s = ImageScraper.new( url, alt: alt)
    s.log_tags = ['scraped_image_spec', :timestamp, :test]
    s
  end

  let(:filename_smaller) { 'example_smaller_scraped_image.jpg' }

  let(:path_smaller) { Rails.root.join('spec', 'scrapers', 'base', 'example_smaller_scraped_image.jpg') }
  let(:path_larger)  { Rails.root.join('spec', 'scrapers', 'base', 'example_larger_scraped_image.jpg') }
  # let(:saved_path)   { Rails.root.join('public', 'system', 'images', 'assets') }
  let(:saved_path)   { Rails.root.join('spec', 'test_files', 'images') }
  let(:uri_smaller)  { URI.join('file:///', path_smaller.to_s) }
  let(:uri_larger)   { URI.join('file:///', path_larger.to_s) }

  let(:topic_scraper) do 
    t = TopicScraper.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
        path:'spec/scrapers/pfa/example_pfa_topic.html',
        log_tags: ['image_scraper', :test]
        )
    t.record = create :topic, scraped: true
    t
  end

  describe 'building Image from ScrapedImage' do
    before(:example) { @image = new_image_scraper }

    describe '#with_temp_image' do
      it 'pulls image into @temp_image' do
        @image.with_temp_image do |img|
          expect(img.size).to be > 100
        end
      end

      it 'has the expected image file path' do
        @image.with_temp_image do |img|
          expect(img.path).to match(/tmp\/#{filename_smaller}/)
        end
      end
    end

    describe '#save_image_to' do
      context 'with new image' do
        before(:example) { @image.save_image_to(topic_scraper) }

        it 'saves file to public/system' do
          expect(@image.record.asset.path).to match(/#{saved_path}.*/)
        end

        it 'persists image on ImageScraper' do
          expect(@image.record.persisted?).to be(true)
        end
      end

      context 'with duplicate image' do
        before(:example) do
          @image.save_image_to(topic_scraper)

          dup_image = new_image_scraper(uri_smaller, alt: 'something same-y')
          dup_image.save_image_to(topic_scraper)
        end

        it 'keeps same id on TopicScraper topic' do
          expect(@image.record).to eq(topic_scraper.record.images.first)
        end

        it 'doesnt add any more images to topic_scraper record' do
          expect(topic_scraper.record.images.length).to eq(1)
        end

        it 'does not make any alteration to the image' do
          expect(topic_scraper.record.images.first.asset_updated_at_changed?).to be(false)
        end

        it 'doesnt even change the alt text' do
          expect(@image.record.alt).not_to eq('something same-y')
        end
      end

      context 'updates existing scraped images because, I think, of inverse_of' do
        before(:example) { @image.save_image_to(topic_scraper) }

        it 'even images start small' do
          expect(@image.record.asset.size).to be < 72113
        end

        it 'grows up' do
          @larger_image = new_image_scraper(uri_larger, alt: 'bigger bugger better')
          @larger_image.save_image_to(topic_scraper)

          expect(@image.record.asset.size).not_to be < 72113
        end
      end

      context 'larger image' do
        before(:example) do
          @image.save_image_to(topic_scraper)

          @larger_image = new_image_scraper(uri_larger, alt: 'bigger bugger butter')
          @larger_image.save_image_to(topic_scraper)
        end

        it 'does not add any more images to TopicScraper record' do
          expect(topic_scraper.record.images.length).to be(1)
        end

        it 'keeps the same id' do
          expect(topic_scraper.record.images.first).to eq(@image.record)
        end

        it 'takes the larger image' do
          expect(@image.record.asset.size).to eq(@larger_image.record.asset.size)
        end

        it 'image does not update the alt text, because whatever its not clear' do
          expect(topic_scraper.record.images.first.alt).not_to eq('bigger bugger butter')
        end
      end
    end
  end
end