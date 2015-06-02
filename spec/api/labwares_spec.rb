#Retrieve location information for a given piece of labware (GET /api/labwares/<barcode>) returns labware object and location object

require "rails_helper"

RSpec.describe Api::LabwaresController, type: :request do 

 let!(:location)  { create(:location_with_parent)}
 let!(:labware)   { create(:labware_with_histories, location: location)}

 before(:each) do
  get api_labware_path(labware.barcode)
 end

 it "should return labware object" do
  expect(response).to be_success
  expect(response.body).to eq(LabwareSerializer.new(labware).to_json)
 end

 it "should return location object associated with labware" do
  expect(ActiveSupport::JSON.decode(response.body)["location"]).to_not be_empty
 end

 it "should return link to labware history" do
  expect(ActiveSupport::JSON.decode(response.body)["history"]).to eq(api_labware_histories_path(labware.barcode))
 end

 it "link to labware history should return history for labware" do
  get ActiveSupport::JSON.decode(response.body)["history"]
  expect(response).to be_success
  expect(response.body).to eq(labware.histories.to_json)
 end

end