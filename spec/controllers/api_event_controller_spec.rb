require 'spec_helper'

describe Api::EventsController do
  render_views

  let(:venue) { FactoryGirl.create(:venue) }
  let(:event) { FactoryGirl.create(:event, venue: venue) }
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
      2.times {FactoryGirl.create(:event)}
      get 'index', format: :json
      # Response holds a JSON document with two objects
      expect(JSON.parse(response.body).length).to eq(2)
    end

    it "assigns @events" do
      e = event
      get 'index', format: :json
      expect(assigns(:events)).to eq([e])
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: event, format: :json
      expect(response).to be_success
    end

    it "does not render a template" do
      get 'show', id: event, format: :json
      expect(response).not_to render_template :show
    end

      it "assigns @event" do
      e = event
      get 'show', id: e, format: :json
      expect(assigns(:event)).to eq(e)
    end
  end
end
