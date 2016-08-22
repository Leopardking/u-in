require 'spec_helper'

describe SchedulesController do

  before do
    User.destroy_all
    @user = FactoryGirl.create(:user)
    @user.update(user_type: User::USER_TYPE[:merchant])
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to render_template(:index)
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
      @schedule_params = {
        schedule_name: "Test new schedule",
        sunday: [true, false].sample,
        monday: [true, false].sample,
        tuesday: [true, false].sample,
        wednesday: [true, false].sample,
        thursday: [true, false].sample,
        friday: [true, false].sample,
        saturday: [true, false].sample,
        start_date: Time.now.to_date,
        end_date: Time.now.to_date,
        start_time: Time.now,
        end_time: Time.now,
        active: [true, false].sample
      }
    end

    it "should create new schedule" do
      expect {
        post :create, working_schedule: @schedule_params
      }.to change(WorkingSchedule, :count).by(1)
      expect(response).to redirect_to(working_schedules_url)
    end
  end

  describe "GET 'edit'" do
    before do
      @schedule = FactoryGirl.create(:working_schedule)
      @schedule.user = @user
      @schedule.save
    end

    it "should render view" do
      get :edit, id: @schedule.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    before do
      @schedule = FactoryGirl.create(:working_schedule)
      @schedule.user = @user
      @schedule.save
      @schedule_params = {
        schedule_name: "My schedule",
        start_date: Time.now.to_date,
        end_date: Time.now.to_date,
        active: true
      }
    end

    it "should update schedule" do
      put :update, working_schedule: @schedule_params, id: @schedule.id
      expect(response).to redirect_to(working_schedules_url)
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @schedule = FactoryGirl.create(:working_schedule)
      @schedule.user = @user
      @schedule.save
    end

    it "should delete schedule" do
      expect{
        delete :destroy, id: @schedule.id
      }.to change(WorkingSchedule, :count).by(-1)
      expect(response).to redirect_to(working_schedules_url)
    end
    it "should not delete schedule" do
      @ary = Array.new
      for i in 0..4
        @c= FactoryGirl.create(:category)
        @ary.push(@c.id)
      end
      @promotion = FactoryGirl.create(:promotion, user: @use, category_ids: @ary)
      @promotion.working_schedule_id = @schedule.id
      @promotion.save
      expect{
        delete :destroy, id: @schedule.id
      }.to change(WorkingSchedule, :count).by(0)

      expect(response).to redirect_to(working_schedules_url)

    end
  end

end
