require 'rails_helper'

RSpec.describe Pin, type: :model do
  before :each do
    @pin = FactoryGirl.create(:pin)
  end

  it "is valid with a title and description" do
    expect(@pin).to be_valid
  end

  it "is invalid without a title" do
    @pin.title = nil;
    expect(@pin).to be_invalid
  end

  it "is invalid without a description" do
    @pin.description = nil;
    expect(@pin).to be_invalid
  end

  it "accepts upvotes" do
    @user = FactoryGirl.create(:user)
    expect{ @pin.upvote_by @user }.to change(@pin, :votes).by(1)
  end

  it "accepts only one upvote per user" do
    @user = FactoryGirl.create(:user)
    @pin.upvote_by @user
    expect{ @pin.upvote_by @user }.not_to change(@pin, :votes)
  end

  it "accepts upvote only from logged in users" do
    @user = nil
    expect{ @pin.upvote_by @user }.not_to change(@pin, :votes)
  end
end
