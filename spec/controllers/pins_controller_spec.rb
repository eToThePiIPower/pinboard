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
      expect(response).to be_ok
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
        expect(response).to render_template :new
        expect(response).to be_ok
      end
    end #when logged in

    context "when not logged in" do
      before :each do
        login_with nil
      end

      it "redirects to the sign in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
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
        expect(response.status).to eq(400) 
      end
    end #when logged in with invalid pin attributes

    context "when not logged in" do
      before :each do
        @valid_attribs = FactoryGirl.attributes_for(:pin)
        login_with nil
      end

      it "does not save the new pin in the database" do
        expect{post :create, pin: @valid_attribs}.not_to change(Pin, :count)
      end

      it "redirects to the sign in page" do
        post :create, pin: FactoryGirl.attributes_for(:pin)
        expect(response).to redirect_to new_user_session_path
      end
    end #when not logged in
  end #POST #create

  describe "GET #show" do
    before :each do
      @pin = FactoryGirl.create(:pin)
      get :show, id: @pin
    end

    it "assigns the requested pin" do
      expect(assigns(:pin)).to eq(@pin)
    end

    it "renders the #show view" do
      expect(response).to render_template :show
      expect(response).to be_ok
    end
  end #GET #show

  describe "GET #edit" do
    before :each do
      @owner = FactoryGirl.create(:user)
      @pin = @owner.pins.create(FactoryGirl.attributes_for(:pin))
    end

    context "when logged in as owner" do
      before :each do
        login_with @owner
        get :edit, id: @pin
      end

      it "assigns a new Pin to @pin" do
        expect(assigns(:pin).title).to eq(@pin.title)
        expect(assigns(:pin).description).to eq(@pin.description)
      end

      it "renders the new Pin form" do
        expect(response).to render_template :edit
        expect(response).to be_ok
      end
    end #when logged in as the owner

    context "when logged in as other user" do
      before :each do
        login_with FactoryGirl.create(:user)
        get :edit, id: @pin
      end

      it "redirects to the show pin form" do
        expect(response).to redirect_to @pin
      end
    end #when logged in as other user

    context "when not logged in" do
      before :each do
        login_with nil
        get :edit, id: @pin
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end #when not logged in
  end #GET #edit

  describe "PUT #update" do
    before :each do
      @owner = FactoryGirl.create(:user)
      @pin = @owner.pins.create(FactoryGirl.attributes_for(:pin))
    end

    context "when logged in as owner with valid attributes" do
      before :each do
        login_with @owner
        @new_pin = FactoryGirl.attributes_for(:pin, title: "New Title")
        put :update, id: @pin, pin: @new_pin
      end

      it "locates the requested @pin" do
        expect(assigns(:pin)).to eq(@pin)
      end

      it "changes @pin's attributes" do
        @pin.reload
        expect(@pin.title).to eq("New Title")
      end

      it "redirects to the updated pin" do
        expect(response).to redirect_to @pin
      end
    end #when logged in as owner with valid attributes

    context "when logged in as owner with invalid attributes" do
      before :each do
        login_with @owner
        @new_pin = FactoryGirl.attributes_for(:invalid_pin)
        put :update, id: @pin, pin: @new_pin
      end

      it "locates the requested @pin" do
        expect(assigns(:pin)).to eq(@pin)
      end

      it "does not change @pin's attributes" do
        @pin.reload
        expect(@pin.title).not_to eq(@new_pin['title'])
        expect(@pin.description).not_to eq(@new_pin['description'])
      end

      it "rerenders the :edit page" do
        expect(response).to render_template :edit
        expect(response.status).to eq(400)
      end
    end #when logged in as creator with invalid attributes

    context "when logged in as another user" do
      before :each do
        login_with FactoryGirl.create(:user)
        put :update, id: @pin, pin: FactoryGirl.attributes_for(:pin, title: "New Title")
      end

      it "does not change @pin's attributes" do
        @pin.reload
        expect(@pin.title).not_to eq("New Title")
      end

      it "redirects to the :show page" do
        expect(response).to redirect_to @pin
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
      end
    end #when logged in as another user

    context "when not logged in" do
      before :each do
        login_with nil
      end

      it "does not delete the pin" do
        expect{delete :destroy, id: @pin}.not_to change(Pin, :count)
      end

      it "redirects to the root page" do
        delete :destroy, id: @pin
        expect(response).to redirect_to new_user_session_path
      end
    end #when not logged in
  end #DELETE #destroy

  describe "PUT #upvote" do
    context "when logged in" do
      before :each do
        @pin = FactoryGirl.create(:pin)
        @user = FactoryGirl.create(:user)
        login_with(@user)
      end

      it "increased the count by onen" do
        expect{ get :upvote, id: @pin }.to change(@pin, :votes).by(1)
      end

      it "does no increased the count a second time for the same user" do
        expect{ get :upvote, id: @pin }.to change(@pin, :votes).by(1)
        expect{ get :upvote, id: @pin }.not_to change(@pin, :votes)
      end

      it "increased the count when a different user votes" do
        expect{ get :upvote, id: @pin }.to change(@pin, :votes).by(1)
        login_with create(:user)
        expect{ get :upvote, id: @pin }.to change(@pin, :votes).by(1)
      end
    end #when logged in

    context "when not logged in" do
      before :each do
        @pin = FactoryGirl.create(:pin)
        login_with(nil)
      end

      it "does not increase the count for an anonyous user" do
        expect{ get :upvote, id: @pin }.not_to change(@pin, :votes)
      end
    end #when not logged in
  end #PUT #upvote
end #describe PinsController
