defmodule Stripe.ManagedAccount.CustomerTest do
  use ExUnit.Case
  alias Stripe.Accounts
  alias Stripe.ManagedAccount.Customers

  setup_all do
    Accounts.delete_all
    account = Helper.create_test_account("test@example.com")
    stripe_account = account.id
    Customers.delete_all(stripe_account)

    new_customer = [
      email: "test@test.com",
      description: "An Elixir Test Account",
    ]

    case Customers.create account.id, new_customer do
      {:ok, customer} ->
        on_exit fn ->
          {:ok, _} = Customers.delete stripe_account, customer.id
          {:ok, _} = Accounts.delete stripe_account
        end
        {:ok, [customer: customer]}

      {:error, err} -> flunk err
    end
  end

  test "Create works", %{customer: customer} do
    assert customer.id
  end
end
