require 'spec_helper'

describe CategoriesController do
  before do
    User.destroy_all
    @admin = FactoryGirl.create(:user, user_type: 'merchant')
    @admin.admin = true
    @admin.save
    sign_in @admin
  end
  describe "GET index" do
    it "should render view" do
      for i in 0..18
        FactoryGirl.create(:category, user: @admin)
      end
      get 'index'
      response.should be_success
      assigns(:categories).should_not be_nil
      assigns(:categories).length.should eq(19)
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
  describe "POST 'create'" do
    before do
      @category_params = {:name => ' Test abc category', user: @admin}
    end
    it "should create category" do
      post :create, category: @category_params, format: :js
      assigns(:categories).length.should eq(1)
      response.should be_success
    end
    it "should not create category when some attributes is invalid" do
      @category_params[:name] = {}
      post :create, category: @category_params, format: :js
      assigns(:categories).length.should eq(0)
      response.should be_success
    end
  end
  describe "PUT 'update'" do
    before do
      @category = FactoryGirl.create(:category, user: @admin)
      @category_params = {:name => 'Test abc category update'}
    end
    it "should update category" do
      put :update, category: @category_params, id: @category.id, format: :js
      @category.reload
      @category.name.should match('Test abc category update')
    end
  end
  describe "DELETE destroy" do
    before do
      @category = FactoryGirl.create(:category, user: @admin)
    end
    it "should destroy category" do
      expect{
        delete :destroy, :id => @category.id, format: :js
      }.to change(Category, :count).by(-1)
    end
    it "should not destroy category" do
      expect{
        delete :destroy, :id => '0', format: :js
      }.to change(Category, :count).by(0)
    end
  end
end
