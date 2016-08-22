require 'spec_helper'

describe PromotionsController do
  before do
    User.destroy_all
    @admin = FactoryGirl.create(:user, user_type: 'merchant')
    @ary = Array.new
    for i in 0..4
      @c= FactoryGirl.create(:category, user_id: @admin.id)
      @ary.push(@c.id)
    end
    sign_in @admin
  end

  describe "GET index" do
    it "should render view" do
      for i in 0..18
        FactoryGirl.create(:promotion, user: @admin, category_ids: @ary)
      end
      get 'index'
      response.should be_success
      assigns(:promotions).should_not be_nil
      assigns(:promotions).length.should eq(19)
    end
     it "should not render view when authorize fail" do
      sign_out @admin
      @admin.user_type = 'client'
      @admin.save
      sign_in @admin.reload
      get 'index'
      response.should redirect_to root_url
      flash[:error].should_not be_nil
     end
  end
  describe "GET 'show'" do
    before do
      @promotion = FactoryGirl.create(:promotion, user: @admin, category_ids: @ary)
    end
    it "show render view" do
      get :show, :id => @promotion.id
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    before do
      @promotion = FactoryGirl.create(:promotion, user: @admin, category_ids: @ary)
    end
    it "returns render view" do
      get :edit, :id => @promotion.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "show render new" do
      get :new
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before do
      @promotion_params =  { :name => '10% Discount', :description => '10% Discount From xxx. to yyy.' , :google_map_link => '', :street_address_1 =>'Wasaco 10 Pho Quang', :street_address_2=> 'Wasaco 10 Pho Quang' , :city => 'HCM', :state => 'HCMC', :zipcode => '70000', :phone_number => '8888888888' , :youtube_video => '', :price  => 200.5, :discount_price => 20.05  , :discount_percent => 10,:start_date => '06/26/2014' , :end_date => '06/30/2014', :repeat => false, :booking_available => 200, :cancellation_minimum => 2, :cancellation_fee => 5, :working_schedule => nil, :user => @admin, :category_ids => @ary }
    end
    it "should create promotion" do
      expect{
        post :create, promotion: @promotion_params, format: :js
      }.to change(Promotion, :count).by(1)
      response.should be_success
    end
    it "should not create promotion when some attributes is invalid" do
      @promotion_params[:category_ids] = {}
      expect{
        post :create, promotion: @promotion_params, format: :js
      }.to change(Promotion, :count).by(0)
      response.should be_success
    end
  end
  describe "PUT 'update'" do
    before do
      @promotion_params =  { :name => '10% Discount', :description => '10% Discount From xxx. to yyy.' , :google_map_link => '', :street_address_1 =>'Wasaco 10 Pho Quang', :street_address_2=> 'Wasaco 10 Pho Quang' , :city => 'HCM', :state => 'HCMC', :zipcode => '70000', :phone_number => '8888888888' , :youtube_video => '', :price  => 200.5, :discount_price => 20.05  , :discount_percent => 10,:start_date => '06/27/2014' , :end_date => '07/07/2014', :repeat => false, :booking_available => 200, :cancellation_minimum => 2, :cancellation_fee => 5, :working_schedule => nil, :user => @admin, :category_ids => @ary, :same_as_business_address => false }
    end
    it "should update promotion" do
      @promotion = FactoryGirl.create(:promotion, user: @admin, category_ids: @ary)
      put :update, promotion: @promotion_params, id: @promotion.id, format: :js
      response.content_type.should == Mime::JS
    end
    it "should not update promotion when some attributes is invalid" do
      @promotion = FactoryGirl.create(:promotion, user: @admin, category_ids: @ary)
      @promotion_params[:category_ids] = {}
      put :update, promotion: @promotion_params,id: @promotion.id, format: :js
      response.should render_template "promotions/errors_create.js.erb"
    end
  end
  describe "GET 'set cancel status'" do
    before do
      @promotion = FactoryGirl.create(:promotion, user: @admin, category_ids: @ary)
    end
    it "show set cancel status" do
      get :set_cancel_reactive_status, id: @promotion.id, status: true
      @promotion.reload
      @promotion.cancel_status.should be_true
      response.should be_success
    end
  end
end
