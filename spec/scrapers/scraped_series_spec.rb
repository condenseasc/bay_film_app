require 'spec_helper'
require_relative '../../lib/scrapers/base_classes/scraped_series'
require_relative '../../lib/scrapers/scrape'


RSpec.describe 'ScrapedSeries' do
  let(:scraped_series) { ScrapedSeries.new }
  let(:test_series) { TestSeries.new }

  before(:all) do
    class TestSeries < ScrapedSeries
      def initialize
        @doc = Nokogiri::HTML::Document.new
      end
    end
  end

  describe 'instance method' do 
    describe 'scrape_#{attr}' do
      context 'scrape_#{attr} method not defined on subclass' do
        it 'method_missing catches and returns nil if attr is in schema' do
          expect(TestSeries.new.scrape_title).to be_nil
        end
      end
    end
  end


end