class HistoryVMoneysController < ApplicationController
  def index
    @histories = current_user.history_v_moneys.page(params[:page])
  end
end
