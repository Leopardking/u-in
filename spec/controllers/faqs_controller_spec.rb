require 'spec_helper'

describe FaqsController do

  before do
    User.destroy_all
    @user = FactoryGirl.create(:user)
    @user.update(user_type: User::USER_TYPE[:admin], admin: false)
    sign_in @user
  end

  describe "GET 'index'" do
    it "should render the :index template" do
      get 'index'
      expect(response).to render_template :index
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to render_template(:new)
    end
  end

  describe "GET 'create'" do
    before do
      @faq_params = FactoryGirl.attributes_for(:faq)
    end

    it "should create new faq" do
      expect {
        post :create, faq: @faq_params
      }.to change(Faq, :count).by(1)
      expect(response).to redirect_to(faqs_url)
    end
  end

  describe "GET 'edit'" do
    before do
      @faq = FactoryGirl.create(:faq)
    end

    it "should render view" do
      get :edit, id: @faq.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    before do
      @faq = FactoryGirl.create(:faq)
      @faq_params = {
        question: "What is love?",
        answer: "Love is nothing"
      }
    end

    it "should update faq" do
      @faq.update(@faq_params).should eq(true)
      put :update, faq: @faq_params, id: @faq.id
      @faq.question.should eq("What is love?")
      @faq.answer.should eq("Love is nothing")
      expect(response).to redirect_to(faqs_url)
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @faq = FactoryGirl.create(:faq)
    end

    it "should delete faq" do
      delete :destroy, id: @faq.id
      expect(response).to redirect_to(faqs_url)
    end
  end

end