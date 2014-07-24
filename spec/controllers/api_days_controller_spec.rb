require 'spec_helper'

describe Api::DaysController do
  let(:venue) { FactoryGirl.create(:venue) }
  let(:event) { FactoryGirl.create(:event, venue: venue, time: Time.now) }
  let(:second_event) { FactoryGirl.create(:event, venue: venue, time: Time.now.advance(days: 1)) }
  let(:series) { FactoryGirl.create(:series) }

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', format: :json
      expect(response).to be_success
    end

    it "does not render a template" do
      get 'index', format: :json
      expect(response).not_to render_template :index
    end

    it "populates a Json array with events" do
      # populate db
      FactoryGirl.create(:event, venue: venue, time: Time.now)
      FactoryGirl.create(:event, venue: venue, time: Time.now.advance(days: 1))

      get 'index', format: :json
      # Response holds a JSON document with two objects
      expect(JSON.parse(response.body).length).to eq(2)
    end

    # it "assigns @days" do
    #   e = event
    #   get 'index', format: :json
    #   expect(assigns(:days)).to eq([])
    # end
  end

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
