require 'rails_helper'

RSpec.describe PinsController, type: :controller do
  describe "GET #index" do
    it "assigns @pins" do
      pin = FactoryGirl.create(:pin)
      get :index
      expect(assigns(:pins)).to eq([pin])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @pins newest first" do
      pin1 = FactoryGirl.create(:pin)
      pin2 = FactoryGirl.create(:pin)
      pin3 = FactoryGirl.create(:pin)
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

  describe "POST #create" do
    context "with valid pin" do
      before :each do
        @valid_attribs = FactoryGirl.attributes_for(:pin)
      end

      it "saves the new pin in the database" do
        expect{post :create, pin: @valid_attribs}.to change(Pin, :count).by(1)
      end

      it "redirects to the root page" do
        post :create, pin: @valid_attribs
        expect(response).to redirect_to :root
      end
    end #with valid pin attributes

    context "with invalid pin attributes" do
      before :each do
        @invalid_attribs = FactoryGirl.attributes_for(:invalid_pin)
      end

      it "does not save the new pin in the database" do
        expect{post :create, pin: @invalid_attribs}.not_to change(Pin, :count)
      end

      it "rerenders the :new page" do
        post :create, pin: @invalid_attribs
        expect(response).to render_template :new
      end
    end #with invalid pin attributes

  end #POST #create

end
