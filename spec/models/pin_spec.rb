require 'rails_helper'

RSpec.describe Pin, type: :model do
  before :each do
    @pin = Pin.new(
      title: "Title",
      description: "A description",
    )
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
end
