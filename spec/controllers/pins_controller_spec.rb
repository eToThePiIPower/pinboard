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
    context "when logged in" do
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
    end #when logged in

    context "when not logged in" do
      before :each do
        login_with nil
        get :new
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to new_user_session_path
        expect(response).not_to be_successful
      end
    end #when not logged in
  end #GET #new

  describe "POST #create" do
    context "when logged in with valid pin" do
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
    end #when logged in with valid pin attributes

    context "when logged in with invalid pin attributes" do
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
    end #when logged in with invalid pin attributes

    context "when not logged in" do
      before :each do
        login_with nil
        post :create, pin: FactoryGirl.attributes_for(:pin)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to new_user_session_path
        expect(response).not_to be_successful
      end
    end #when not logged in
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
    context "when logged in as creator" do
      before :each do
        @user = FactoryGirl.create(:user)
        @pin = @user.pins.create(FactoryGirl.attributes_for(:pin))
        login_with @user
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
    end #when logged in

    context "when logged in as other user" do
      before :each do
        @owner = FactoryGirl.create(:user)
        @user = FactoryGirl.create(:user)
        @pin = @owner.pins.create(FactoryGirl.attributes_for(:pin))
        login_with @user
        get :edit, id: @pin
      end

      it "redirects to the show pin form" do
        expect(response).to redirect_to @pin
        expect(response).not_to be_ok
      end
    end #when logged in
  end #GET #edit

  describe "PUT #update" do
    before :each do
      @owner = FactoryGirl.create(:user)
      @pin = @owner.pins.create(FactoryGirl.attributes_for(:pin))
    end

    context "when logged in as creator with valid attributes" do
      before :each do
        login_with @owner
      end

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
    end #when logged in as creator with valid attributes

    context "when logged in as creator with invalid attributes" do
      before :each do
        login_with @owner
      end

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
    end #when logged in as creator with invalid attributes

    context "when logged in as another user" do
      before :each do
        login_with FactoryGirl.create(:user)
      end

      it "does not change @pin's attributes" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin, title: "New Title")
        @pin.reload
        expect(@pin.title).not_to eq("New Title")
      end

      it "redirects to the :show page" do
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin)
        expect(response).to redirect_to @pin
        expect(response).not_to be_ok
      end
    end
  end #PUT #update

  describe "DELETE #destroy" do
    before :each do
      @owner = FactoryGirl.create(:user)
      @pin = @owner.pins.create(FactoryGirl.attributes_for(:pin))
    end

    context "when logged in as the creator" do
      before :each do
        login_with @owner
      end

      it "deletes the pin" do
        expect{delete :destroy, id: @pin}.to change(Pin, :count).by(-1)
      end

      it "redirects to the root page" do
        delete :destroy, id: @pin
        expect(response).to redirect_to :root
      end
    end #when logged in as the creator

    context "when logged in as another user" do
      before :each do
        login_with create(:user)
      end

      it "does not delete the pin" do
        expect{delete :destroy, id: @pin}.not_to change(Pin, :count)
      end

      it "redirects to the root page" do
        delete :destroy, id: @pin
        expect(response).to redirect_to @pin
        expect(response).not_to be_ok
      end
    end #when logged in as another user
  end #DELETE #destroy
end #describe PinsController
