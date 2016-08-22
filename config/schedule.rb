# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
['7am','7pm'].each do |at|
  every :day, :at => at  do
    runner "Promotion.delay.do_current_rank"
  end
end
# every 1.minutes do
#   runner "Promotion.do_current_rank"
# end

# every 30.month, :at => '00:00' do
#   rake 'update_number_book_free:book_free_merchant'
# end
every 5.minutes do
  rake 'update_number_book_free:book_free_merchant'
end

# every 5.minutes do
#   command "echo 'one' && echo 'two'"
# end