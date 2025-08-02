require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do
    it "returns a list of products in JSON format" do
      get "/products"

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end
end
