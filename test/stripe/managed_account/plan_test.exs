defmodule Stripe.ManagedAccount.PlanTest do
  use ExUnit.Case
  alias Stripe.Accounts
  alias Stripe.ManagedAccount.Plans

  setup_all do
    Accounts.delete_all
    account = Helper.create_test_account("test@example.com")

    stripe_account = account.id
    Plans.delete_all(stripe_account)

    new_plan = [
      id: "gold-plan",
      name: "Gold plan",
      amount: 1000
    ]

    case Plans.create account.id, new_plan do
      {:ok, plan} ->
        on_exit fn ->
          {:ok, _} = Plans.delete stripe_account, plan.id
          {:ok, _} = Accounts.delete stripe_account
        end
        {:ok, [plan: plan]}

      {:error, err} -> flunk err
    end
  end

  test "Create works", %{plan: plan} do
    assert plan.id
  end
end
