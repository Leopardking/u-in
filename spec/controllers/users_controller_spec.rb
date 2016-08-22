require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers
  before do
    User.destroy_all
    @admin = FactoryGirl.create(:user, user_type: 'merchant')
    @admin.admin=true
    @admin.save
    sign_in @admin
    for i in 1..15
      @user = FactoryGirl.create(:user, user_type: 'merchant')
    end
  end
  describe "GET 'index'" do
    it "should render view with 15 user" do
      get :index
      response.should be_success
      assigns(:users).should_not be_nil
      assigns(:users).length.should eq(15)
    end
    it "should not render view when authorize fail" do
      sign_out @admin
      @admin.admin = false
      @admin.save
      sign_in @admin.reload
      get 'index'
      response.should redirect_to root_url
      flash[:error].should_not be_nil
     end
  end
  describe "DELETE 'destroy'" do
    it "should destroy user" do
      expect{
       delete :destroy, id: User.first.id, format: :js
      }.to change(User, :count).by(-1)
      response.should render_template "users/destroy"
    end
  end
end
