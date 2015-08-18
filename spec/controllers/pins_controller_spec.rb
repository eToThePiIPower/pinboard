require 'rails_helper'

RSpec.describe PinsController, type: :controller do
  describe "GET #index" do
    it "assigns @pins" do
      pin = Pin.create(title: "Test", description: "123")
      get :index
      expect(assigns(:pins)).to eq([pin])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @pins newest first" do
      pin1 = Pin.create(title: "A", description: "123")
      pin2 = Pin.create(title: "C", description: "123")
      pin3 = Pin.create(title: "B", description: "123")
      get :index
      expect(assigns(:pins)).to eq([pin3, pin2, pin1])
    end
  end #GET #index

  describe "GET #new" do
    it "assigns a new Pin to @pin" do
      get :new
      expect(assigns(:pin).title).to be_nil
      expect(assigns(:pin).description).to be_nil
    end
  end #GET #new

end
