require 'spec_helper'

describe Api::DaysController do
  render_views

  let(:topic)        { create :topic }
  let(:event)        { create :event, time: Time.now, topic: topic }
  let(:second_event) { create :event, time: Time.now.advance(days: 1), topic: topic }

  describe "GET 'show'" do
    
    it "returns http success" do
      get 'show', id: Day.day_id(event.time), format: :json
      expect(response).to be_success
    end

    it "does not render a template" do
      get 'show', id: Day.day_id(event.time), format: :json
      expect(response).not_to render_template :show
    end

    it "has an 'events' array" do
      get 'show', id: Day.day_id(event.time), format: :json
      day = JSON.parse(response.body)
      expect(day["events"].is_a? Array).to be(true)
      expect(day["events"].length).to be(1)
    end

    it "represents events using the EventsSerializer" do
      get 'show', id: Day.day_id(event.time), format: :json
      day = JSON.parse(response.body)
      expect(day["events"][0].keys).not_to include("still_fingerprint", "still_updated_at")
    end

    # it "assigns @days" do
    #   e = event
    #   get 'show', id: e, format: :json
    #   expect(assigns(:event)).to eq()
    # end
  end
end
