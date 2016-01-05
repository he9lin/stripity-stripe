defmodule Stripe.ManagedAccount.SubscriptionTest do
  use ExUnit.Case
  alias Stripe.Accounts
  alias Stripe.ManagedAccount.Subscriptions
  alias Stripe.ManagedAccount.Plans
  alias Stripe.ManagedAccount.Customers

  setup_all do
    Accounts.delete_all
    account = Helper.create_test_account("test@example.com")
    stripe_account = account.id

    token_params = [
      card: [
        number: "4111111111111111",
        exp_month: 01,
        exp_year: 2018,
        cvc: 123,
        name: "Joe Test User"
      ]
    ]

    {:ok, token} = Stripe.Tokens.create token_params

    new_customer = [
      email: "test@test.com",
      description: "An Elixir Test Account"
    ]
    {:ok, customer} = Customers.create stripe_account, new_customer

    new_plan = [
      id: "gold-plan",
      name: "Gold plan",
      amount: 1000
    ]
    {:ok, plan} = Plans.create stripe_account, new_plan

    new_subscription = [
      plan: plan.id, source: token.id
    ]

    case Subscriptions.create stripe_account, customer.id, new_subscription do
      {:ok, subscription} ->
        on_exit fn ->
          {:ok, _} = Subscriptions.delete stripe_account, customer.id, subscription.id
          {:ok, _} = Customers.delete stripe_account, customer.id
          {:ok, _} = Plans.delete stripe_account, plan.id
          {:ok, _} = Accounts.delete stripe_account
        end
        {:ok, [subscription: subscription]}

      {:error, err} -> flunk err
    end
  end

  test "Create works", %{subscription: subscription} do
    assert subscription.id
  end
end
