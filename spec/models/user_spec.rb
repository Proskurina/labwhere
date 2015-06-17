require 'rails_helper'

RSpec.describe User, type: :model do

  it "should not be valid without a login" do
    expect(build(:user, login: nil)).to_not be_valid
  end

  it "should be valid without a swipe card Id" do
    expect(build(:user, swipe_card_id: nil)).to be_valid
  end

  it "should allow blank or nil swipe card id" do
    create(:user, swipe_card_id: nil)
    expect(build(:user, swipe_card_id: nil)).to be_valid
  end

  it "should allow blank or nil barcode" do
    create(:user, barcode: nil)
    expect(build(:user, barcode: nil)).to be_valid
  end

  it "should be valid without a barcode" do
    expect(build(:user, barcode: nil)).to be_valid
  end

  it "should not be valid without a unique login" do
    user = create(:user)
    expect(build(:user, login: user.login)).to_not be_valid
  end

  it "should not be valid without a unique swipe card" do
    user = create(:user)
    expect(build(:user, swipe_card_id: user.swipe_card_id)).to_not be_valid
  end

  it "should not be valid without a unique barcode" do
    user = create(:user)
    expect(build(:user, barcode: user.barcode)).to_not be_valid
  end

  it "should not be valid without a team" do
    expect(build(:user, team: nil)).to_not be_valid
  end

  it "should not be valid without a swipe card id or barcode" do
    user = build(:user, swipe_card_id: nil, barcode: nil)
    expect(user).to_not be_valid
    expect(user.errors.full_messages).to include("Swipe card or Barcode must be completed")

  end

  it "should be able to create an Admin user" do
    user = create(:user, type: "Admin")
    expect(Admin.all.count).to eq(1)
  end

  it "should be able to create an Standard user" do
    user = create(:user, type: "Standard")
    expect(Standard.all.count).to eq(1)
  end

  it "should not be a guest" do
    expect(build(:user)).to_not be_guest
  end

  it "Admin use should be allowed to do anything" do
    expect(build(:admin)).to allow_permission(:any, :thing)
  end

  it "Standard user should be allowed to create a scan" do
    expect(build(:standard)).to allow_permission(:scans, :create)
  end

  it "#find_by_code should be able to find user by swipe card id or barcode" do
    users = create_list(:user, 4)
    user = build(:user)
    expect(User.find_by_code(users.first.swipe_card_id)).to eq(users.first)
    expect(User.find_by_code(users.first.barcode)).to eq(users.first)
    expect(User.find_by_code(user.swipe_card_id)).to be_guest
  end

  it "find_by_code should always return a guest user if code is empty" do
    user = create(:user, swipe_card_id: "")
    expect(User.find_by_code(nil)).to be_guest
    expect(User.find_by_code(user.swipe_card_id)).to be_guest
  end

end
