class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)
        if @user.present?
          sign_in_and_redirect @user, event: :authentication and return
          set_flash_message(:notice, :success, kind: #{provider}.capitalize) if is_navigational_format?
        else
          session[:provider] = "#{provider}"
          session[:uid] = env["omniauth.auth"].uid
          if session[:provider] == "instagram"
            session[:name] = env["omniauth.auth"].extra.raw_info.username
          else
            session[:name] = env["omniauth.auth"].extra.raw_info.name
          end
          session[:email] = case session[:provider]
            when "twitter"
              env["omniauth.auth"].uid+"@twitter.com"
            when "facebook"
              env["omniauth.auth"].uid+"@facebook.com"
            when "instagram"
              env["omniauth.auth"].extra.raw_info.id+"@instagram.com"
            else
              env["omniauth.auth"].info.email
          end
          session[:password] = Devise.friendly_token[0,20]
          redirect_to new_user_registration_path
        end
      end
    }
  end

  [:twitter, :facebook, :google_oauth2, :linkedin, :instagram].each do |provider|
    provides_callback_for provider
  end
end
