class SchedulesController < ApplicationController

  before_filter :load_schedule, only: [:check_conflict,:edit, :update, :destroy, :show, :update_status]

  ##
  # GET /schedules
  def index
    authorize! :manage, WorkingSchedule
    @schedules = current_user.working_schedules.load
  end

  ##
  # GET /schedules/:id
  def show
  end

  ##
  # GET /schedules/new
  def new
    @show_employee_schedule = false
    authorize! :manage, WorkingSchedule
    @schedule = WorkingSchedule.new
    0.upto(6) do |day|
      @schedule.working_days.build(day_of_week: day)
    end
    if params[:schedule_type] == "employee"
      @asset = Employee.find_by_id(params[:employee_id])
      params[:employee_schedules] = true
    elsif params[:schedule_type] == "equipment"
      @asset = Equipment.find_by_id(params[:equipment_id])
      params[:equipment_schedules] = true
    end
    #To make the further actions behave as per employee/equipment, set the value of employee_schedules to true
    if params[:employee_schedules] || params[:equipment_schedules]
      @merchant = params[:merchant_id] ? Merchant.find_by_id(params[:merchant_id]) : current_user
    end
  end

  ##
  # POST /schedules
  # This action is changed to ajax call, to handle employee schedule creations.
  def create
    @schedule = current_user.working_schedules.new(schedule_params)
    if @schedule.save
      @schedule.working_days.each do |wd|
        if wd.open
          wd.delay.generate_segment
        end
      end

      if params[:employee_schedules].present?
        @asset = EmployeeSchedule.create(working_schedule_id: @schedule.id, employee_id: params[:employee_id])
      elsif params[:equipment_schedules].present?
        @asset = EquipmentSchedule.create(working_schedule_id: @schedule.id, equipment_id: params[:equipment_id])
      end

      respond_to do |format|
        flash[:notice] = t(".create_working_schedule_successfully")
        flash.keep(:notice)
        if params[:employee_schedules].present? || params[:equipment_schedules].present?
          format.js
        else
          format.js { render :js => "window.location.replace('#{working_schedules_url}');" }
        end
      end
    else
      # same as before - render :new
      respond_to do |format|
        format.js
      end
    end
  end

  ##
  # GET /schedules/:id
  def edit
    authorize! :manage, @schedule
    if @schedule.nil?
      redirect_to working_schedules_url, alert: t(".can_not_found_this_schedule")
    end
  end

  ##
  # PUT /schedules/:id
  def update
    authorize! :manage, WorkingSchedule
    schedule_all = @schedule.working_days
    params[:working_schedule][:working_days_attributes].each do |wd|
      if wd[1]['open'] == "1"
        if  wd[1]['start_time'] != schedule_all.select{|i| i.id == wd[1]['id'].to_i}.first.start_time.strftime("%I:%M %p") || wd[1]['end_time'] != schedule_all.select{|i| i.id == wd[1]['id'].to_i}.first.end_time.strftime("%I:%M %p") || wd[1]['segment'].to_i !=schedule_all.select{|i| i.id == wd[1]['id'].to_i}.first.segment || wd[1]['segment_duration'].to_i != schedule_all.select{|i| i.id == wd[1]['id'].to_i}.first.segment_duration
          @schedule.working_days.find_by_id(wd[1]['id']).segments.destroy_all
          @schedule.working_days.find_by_id(wd[1]['id']).delay.generate_segment
        end
      end
    end
    if @schedule.update(schedule_params)
      respond_to do |format|
        flash[:notice] = t(".udate_working_schedule_successfully")
        flash.keep(:notice)
        # Once the schedule is created redirect to index page
        format.js { render :js => "window.location.replace('#{working_schedules_url}');" }
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  ##
  # DELETE /schedules/:id
  def destroy
    authorize! :manage, WorkingSchedule
    @promotion = Promotion.joins(:working_schedules).where("working_schedules.id = ?", @schedule.id)
    if @promotion.empty?
      @schedule.destroy
      redirect_to working_schedules_url, notice: t(".delete_working_schedule_successfully")
    else
      redirect_to working_schedules_url, alert: t(".delete_working_schedule_fail")
    end
  end

  ##
  # POST /schedules/:id/update_status
  def update_status
    @schedules = []
    authorize! :manage, WorkingSchedule
    flag = false
    active = params[:active].present? && params[:active] == "true" ? true : false
    arr_wd_sche_now = @schedule.working_days.select("day_of_week").where(open: true).map{ |w| w.day_of_week}
    user_schedules = current_user.working_schedules.where("active = TRUE").where.not(id: params[:id])
    #compare the @schedule with all normal schedules
    user_schedules.each{ |schedule| @schedules.push(schedule) unless schedule.business_schedule? }
    unless @schedule.business_schedule?
      @schedules.each do |sc|
        arr_wd_sches = sc.working_days.select("day_of_week").where(open: true).map{ |w| w.day_of_week}
        arr_wd_sches.each do |c|
          if  arr_wd_sche_now.include? c
            flag = true
          end
        end
      end
    end
    if @schedule.working_days.select("day_of_week").where(open: true).empty?
      render json: {flag: nil, promotions: false}
    elsif flag
      render json: {flag: flag, promotions: false}
    else
      if @schedule.update(active: active)
        render json: {flag: flag, promotions: false}
      else
        render json: {flag: flag, promotions: false}
      end
    end
  end
  ##
  #GET AJAX
  # Check conflict schedule.
  def check_conflict

    params[:id] = params[:id] ? params[:id] : 0
    flag = false
    arr_wd_sche_now = params[:a_day_check].each.map{|c| c.to_i}
    if params[:repeat_sche] == "false"
      start_date = format_date(params[:start_date])
      end_date = format_date(params[:end_date])
      @schedules = current_user.working_schedules.where("(:start_date BETWEEN start_date AND end_date) AND (:end_date BETWEEN start_date AND end_date) AND active = TRUE",start_date: start_date, end_date: end_date).where.not(id: params[:id])
      @schedules.each do |sc|
        arr_wd_sches = sc.working_days.select("day_of_week").where(open: true).map{ |w| w.day_of_week}
        arr_wd_sches.each do |c|
          if  arr_wd_sche_now.include? c
            flag = true
          end
        end
      end
      render json: flag
    else
      start_date = format_date(params[:start_date])
      @schedules = current_user.working_schedules.where("(end_date >= :today) AND active = TRUE",today: Date.today).where.not(id: params[:id])
      @schedules.each do |sc|
        arr_wd_sches = sc.working_days.select("day_of_week").where(open: true).map{ |w| w.day_of_week}
        arr_wd_sches.each do |c|
          if  arr_wd_sche_now.include? c
            flag = true
          end
        end
      end
      render json: flag
    end
  end

  # post /schedules/apply_schedule_to_all to apply the same schedules to all of the employees/equipments
  def apply_schedule_to_all
    common_schedule_params = schedule_params #this is to process the params only once. rather than calling inside each.
    @merchant = Merchant.find_by_id(params[:merchant_id])
    if params[:employee_schedules].present?
      @merchant.employees.each do |employee|
        @schedule = current_user.working_schedules.new(common_schedule_params)
        @schedule.schedule_name = employee.name
        if @schedule.save
          @schedule.working_days.each do |wd|
            wd.delay.generate_segment if wd.open
          end
          EmployeeSchedule.create(working_schedule_id: @schedule.id, employee_id: employee.id)
        end
      end
    elsif params[:equipment_schedules].present?
      @merchant.equipments.each do |equipment|
        @schedule = current_user.working_schedules.new(common_schedule_params)
        @schedule.schedule_name = equipment.name
        if @schedule.save
          @schedule.working_days.each do |wd|
            wd.delay.generate_segment if wd.open
          end
          EquipmentSchedule.create(working_schedule_id: @schedule.id, equipment_id:equipment.id)
        end
      end
    end

    if params[:schedule_type] == "to_all"
      @schedule.schedule_name += "- #{params[:working_schedule][:schedule_name]}"
    end
    respond_to do |format|
      flash[:notice] = t(".create_working_schedule_successfully")
      flash.keep(:notice)
      format.js { render :js => "window.location.replace('#{working_schedules_url}');" }
    end
  end

  private
    def schedule_params
      params[:working_schedule][:start_date] = format_date(params[:working_schedule][:start_date])
      params[:working_schedule][:end_date] = format_date(params[:working_schedule][:end_date])
      if params[:working_schedule][:repeat] == "1"
        params[:working_schedule][:end_date] = nil
      end
      strong_param = params.require(:working_schedule).permit(
        :schedule_name,
        :start_date,
        :end_date,
        :repeat,
        working_days_attributes: [
          :id,
          :day_of_week,
          :break_time,
          :break_duration,
          :start_time,
          :end_time,
          :open,
          :lunch_hour,
          :segment,
          :segment_duration,
          # :available_spots
        ]
      )
      strong_param[:working_days_attributes].each do |k, v|
        unless v[:open] == "1"
          v[:segment] = ""
          v[:segment_duration] = ""
          v[:start_time] = "08:00 AM"
          v[:end_time] = "05:00 PM"
          v[:lunch_hour] = "12:00 PM"
        end
      end
      strong_param
    end

    def format_date(input)
      DateTime.strptime(input, "%m/%d/%Y")
    end

    def load_schedule
      @schedule = current_user.working_schedules.find_by_id(params[:id])
    end
end
