window.Pages['StripeProcess'] =
  init: ->
  createCardToken: (number, cvc, exp_month, exp_year, stripeResponse) ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    Stripe.card.createToken({
      number: number,
      cvc: cvc,
      exp_month: exp_month,
      exp_year: exp_year,
      currency: JSConstant.DEFAULT_CURRENCY
      }, stripeResponse)
