namespace :update_data_user do
  task update_info_user: :environment do
    User.find_each do |user|
      user.phone_number = "0987654322"
      if user.first_name.nil?
        user.first_name = "John"
      end
      if user.last_name.nil?
        user.last_name = "Lowe"
      end
      user.save
    end
  end
end

