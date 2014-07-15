require 'spec_helper'

describe Day do
  let(:event) { FactoryGirl.create(:event) }
  let(:day) { Day.new(event.time) }
  let(:day_json) { DaySerializer.new(day).to_json }

  describe 'date to id' do
    before :each do
      t = Time.new(2013, 4, 5)
      @d = Day.new(t)
    end

    # maybe change to date: iso8601 date string
    it 'returns a string formatted as YYYYMMDD' do
      expect(@d.id).to eq('20130405')
    end
  end

  describe 'day generated from events' do
    it 'returns a hash with date in YYYYMMDD as id' do
      # expect(day.id).to be()
    end

    it 'returns a hash with an array of events' do
      expect(day.event_array.is_a? Array).to be(true)
    end

    describe 'serialized' do
      before(:each) do
        @json_response = JSON.parse(day_json)
        puts @json_response
      end

      it 'is a valid JSON object' do
        expect(@json_response['events'][0].keys).to include('title', 'time', 'description', 'venue') 
      end
    end
  end
end
