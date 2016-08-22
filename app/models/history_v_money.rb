class HistoryVMoney < ActiveRecord::Base
  belongs_to :user
  belongs_to :promotion
  ACTION = {
    0 => I18n.t("models.history_v_moneys.refund_v_money"),
    1 => I18n.t("models.history_v_moneys.refund_r_money"),
    2 => I18n.t("models.history_v_moneys.change_v_money"),
    3 => I18n.t("models.history_v_moneys.book_using_v_money")
  }
end
