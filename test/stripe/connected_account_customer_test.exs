defmodule Stripe.AccountCustomerTest do
  use ExUnit.Case

  setup_all do
    stripe_account = "acct_17NZ5REVhgDzSN3o"

    Stripe.AccountCustomers.delete_all(stripe_account)

    new_customer = [
      email: "test@test.com",
      description: "An Elixir Test Account",
    ]

    case Stripe.AccountCustomers.create stripe_account, new_customer do
      {:ok, customer} ->
        on_exit fn ->
          Stripe.AccountCustomers.delete stripe_account, customer.id
        end
        {:ok, [customer: customer]}

      {:error, err} -> flunk err
    end
  end

  test "Create works", %{customer: customer} do
    assert customer.id
  end
end
