class AddColumnsToBookingDetail < ActiveRecord::Migration
   def up
    add_column :booking_details, :booking_detailable_id, :integer
    add_column :booking_details, :booking_detailable_type, :string
    BookingDetail.transaction do
      BookingDetail.find_each do |pt|
        pt.update_attributes(booking_detailable_id: pt.promotion_id, booking_detailable_type: "Promotion")
      end
    end

    remove_column :booking_details, :promotion_id
  end

  def down
    add_column :booking_details, :promotion_id, :integer
    BookingDetail.transaction do
      BookingDetail.find_each do |pt|
        pt.update_attributes(promotion_id: pt.booking_detailable_id)
      end
    end
    remove_column :booking_details, :booking_detailable_id, :integer
    remove_column :booking_details, :booking_detailable_type, :string
  end
end
