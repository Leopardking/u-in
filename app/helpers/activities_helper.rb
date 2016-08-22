module ActivitiesHelper
  def full_or_not(working_schedule_type, booked_day, booking_available, segment_id, date)
    if working_schedule_type == 1
      book_size = booked_day.select{|b| b.book_date == date && b.segment_id == segment_id }.size
      book_size <= booking_available
    else
      book_size = booked_day.select{|b| b.book_date == date}.size
      if working_schedule_type == 2 # Working Schedule for HalfDay
        book_size <= booking_available*2
      else # Working Schedule for FullDay
        book_size <= booking_available
      end
    end
  end
end
