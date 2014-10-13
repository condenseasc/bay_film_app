require 'spec_helper'
require 'scrape/base/topic_scraper'
require 'scrape/base/site_scraper'
require 'scrape/pfa/pfa_topic'
require 'scrape/pfa/pfa_calendar'
require 'compare'

RSpec.describe TopicScraper do
  def scraper
    s = scrapeable_topic
    s.record = topic
    s
  end

  def scrapeable_topic
    PfaTopic.new( 'http://www.bampfa.berkeley.edu/film/FN20724', 
      path:'spec/scrapers/pfa/example_pfa_topic.html', 
      calendar_scraper: PfaCalendar.new('http://www.bampfa.berkeley.edu/filmseries/ray', 
        path:'spec/scrapers/pfa/example_pfa_calendar.html',
        log_tags: ['topic_scraper_spec', :test]
        ),
      log_tags: ['topic_scraper_spec', :test]
    )
  end

  let( :topic )          { build :topic, scraped: true }
  let( :persisted_topic) { create :topic, scraped: true}
  let( :venue )          { build :venue }

  describe "#scrape and #save" do

    context 'under normal circumstances' do
      before(:example) { @scraper = scrapeable_topic; @scraper.scrape }

      it 'has a Topic' do
        expect( @scraper.record.class ).to be(Topic)
      end

      it "starts out with an unsaved topic in @record" do
        expect( @scraper.record.new_record? ).to be(true)
      end

      it 'holds a persisted topic in @record' do
        Topic.destroy_all
        @scraper.save
        expect( @scraper.record.persisted? ).to be(true)
      end
    end

    context 'with a duplicate topic' do
      before(:example) { Topic.destroy_all; scraper.save }

      let(:dup_topic) { Topic.new( topic.attributes.reject { |k,v| k == 'id' } ) }
      let(:dup_scraper) do        
        topic_scraper = scraper
        topic_scraper.record = dup_topic
        topic_scraper
      end

      let(:record_after_save) { dup_scraper.save; dup_scraper.record }

      it "does not save a record with identical attributes" do
        diff = Compare::Records.attribute_difference_between(scraper.record, record_after_save)
        expect( diff ).to be(nil)
        expect( record_after_save.updated_at ).to eq(record_after_save.created_at)
      end

      it 'returns matching persisted record' do
        # expect(record_after_save).to eq(topic)
        expect(record_after_save).to eq(scraper.record)
      end
    end

    context 'with updated topic' do
      before(:example)      { scraper.save }
      let(:updated_topic)   { t = Topic.new(persisted_topic.attributes); t.body = "fresh text!"; t }
      let(:updated_scraper) { s = scraper; s.record = updated_topic; s }
      let(:record_after_save)  { updated_scraper.save; updated_scraper.record }

      it 'updates existing record' do
        expect(persisted_topic.created_at).to eq(record_after_save.created_at)
        expect(record_after_save.created_at).not_to eq(record_after_save.updated_at)
      end

      it 'persists the record' do
        expect(record_after_save.persisted?).to be true
      end

      # it 'has topic returned as returned_topic and all that' do
      #   expect(record_after_save).to eq(persisted_topic)
      # end

      it 'has the right update' do
        expect(record_after_save.body).to eq('fresh text!')
      end

      it 'did not mess up the other fields' do
        diff = Compare::Records.attribute_difference_between(persisted_topic, record_after_save)
        expect(diff).to eq({body: 'fresh text!'})
      end 
    end

    context 'with invalid topic' do
      before(:example) { Topic.destroy_all }
      let(:invalid_topic)      { t = topic; t.title = nil; t }
      let(:invalid_scraper)    { s = scraper; s.record = invalid_topic; s}
      let(:record_after_save)  { invalid_scraper.save; invalid_scraper.record }

      it 'returns nil' do
        expect(record_after_save.valid?).to be false
        expect(Topic.count).to be 0
      end
    end
  end
end