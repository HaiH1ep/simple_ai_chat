require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #health" do
    it "returns a successful response" do
      get :health
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['redis_status']).to be true
      expect(json_response['openai_status']).to be true
    end
  end
end
