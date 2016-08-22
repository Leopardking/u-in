Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]
Stripe.api_key = Rails.configuration.stripe[:secret_key]
