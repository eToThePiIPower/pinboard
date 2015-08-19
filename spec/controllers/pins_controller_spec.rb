require 'rails_helper'

RSpec.describe PinsController, type: :controller do
  render_views
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
    before :each do
      login_with create(:user)
      get :new
    end

    it "assigns a new Pin to @pin" do
      expect(assigns(:pin).title).to be_nil
      expect(assigns(:pin).description).to be_nil
    end

    it "renders the new Pin form" do
      expect(response).to be_ok 
      expect(response).to render_template :new
    end
  end #GET #new

  describe "POST #create" do
    context "with valid pin" do
      before :each do
        @valid_attribs = FactoryGirl.attributes_for(:pin)
        login_with create(:user)
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
        login_with create(:user)
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

  describe "GET #show" do
    it "assigns the requested pin" do
      pin = FactoryGirl.create(:pin)
      get :show, id: pin
      expect(assigns(:pin)).to eq(pin)
    end

    it "renders the #show view" do
      get :show, id: FactoryGirl.create(:pin)
      expect(response).to render_template :show
    end
  end #GET #show

  describe "GET #edit" do
    before :each do
      @pin = FactoryGirl.create(:pin)
      login_with create(:user)
      get :edit, id: @pin
    end

    it "assigns a new Pin to @pin" do
      expect(assigns(:pin).title).to eq(@pin.title) 
      expect(assigns(:pin).description).to eq(@pin.description) 
    end

    it "renders the new Pin form" do
      expect(response).to be_ok 
      expect(response).to render_template :edit
    end
  end #GET #edit

  describe "PUT #update" do
    before :each do
      @pin = FactoryGirl.create(:pin)
      login_with create(:user)
    end

    context "with valid attributes" do
      it "locates the requested @pin" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin)
        expect(assigns(:pin)).to eq(@pin)
      end

      it "changes @pin's attributes" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin, title: "New Title")
        @pin.reload
        expect(@pin.title).to eq("New Title")
      end

      it "redirects to the updated pin" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin)
        expect(response).to redirect_to @pin
      end
    end #with valid attributes

    context "with invalid attributes" do
      it "locates the requested @pin" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:invalid_pin)
        expect(assigns(:pin)).to eq(@pin)
      end

      it "does not change @pin's attributes" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin, title: "New Title", description: nil)
        @pin.reload
        expect(@pin.title).not_to eq("New Title")
      end

      it "rerenders the :edit page" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:invalid_pin)
        expect(response).to render_template :edit
      end
    end #with invalid attributes
  end #PUT #update

  describe "DELETE #destroy" do
    before :each do
      @pin = FactoryGirl.create(:pin)
      login_with create(:user)
    end

    it "deletes the pin" do
      expect{delete :destroy, id: @pin}.to change(Pin, :count).by(-1)
    end

    it "redirects to the root page" do
      delete :destroy, id: @pin
      expect(response).to redirect_to :root
    end
  end

end
