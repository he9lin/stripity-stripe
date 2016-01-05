defmodule Stripe.ManagedAccount.Plans do
  @endpoint "plans"

  alias Stripe.ManagedAccount.ApiOperations

  def create(stripe_account, params) do
    params = Keyword.put_new params, :currency, "USD"
    params = Keyword.put_new params, :interval, "month"

    ApiOperations.create(@endpoint, stripe_account, params)
  end

  def delete(stripe_account, id) do
    ApiOperations.delete(@endpoint, stripe_account, id)
  end

  def delete_all(stripe_account) do
    ApiOperations.delete_all(@endpoint, stripe_account)
  end

  def all(stripe_account, accum \\ [], startingAfter \\ "") do
    ApiOperations.all(@endpoint, stripe_account, accum, startingAfter)
  end
end
