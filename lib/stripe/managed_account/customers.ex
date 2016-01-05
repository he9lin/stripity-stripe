defmodule Stripe.ManagedAccount.Customers do
  @endpoint "customers"

  alias Stripe.ManagedAccount.ApiOperations

  def create(stripe_account, params) do
    ApiOperations.create(@endpoint, stripe_account, params)
  end

  def delete(stripe_account, id) do
    ApiOperations.delete(@endpoint, stripe_account, id)
  end

  def change(stripe_account, id, params) do
    ApiOperations.change(@endpoint, stripe_account, id, params)
  end

  def delete_all(stripe_account) do
    ApiOperations.delete_all(@endpoint, stripe_account)
  end

  def all(stripe_account, accum \\ [], startingAfter \\ "") do
    ApiOperations.all(@endpoint, stripe_account, accum, startingAfter)
  end
end
