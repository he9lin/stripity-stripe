defmodule Stripe.ManagedAccount.Subscriptions do
  @endpoint "customers"

  alias Stripe.ManagedAccount.ApiOperations

  def create(stripe_account, customer_id, params) do
    customer_id
    |> build_path
    |> ApiOperations.create(stripe_account, params)
  end

  def delete(stripe_account, customer_id, id) do
    customer_id
    |> build_path
    |> ApiOperations.delete(stripe_account, id)
  end

  def delete_all(stripe_account, customer_id) do
    customer_id
    |> build_path
    |> ApiOperations.delete_all(stripe_account)
  end

  def all(stripe_account, customer_id, accum \\ [], startingAfter \\ "") do
    customer_id
    |> build_path
    |> ApiOperations.all(stripe_account, accum, startingAfter)
  end

  defp build_path(customer_id, sub_id \\ nil) do
    "#{@endpoint}/#{customer_id}/subscriptions"
  end
end
