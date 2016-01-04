defmodule Stripe.AccountCustomerTest do
  use ExUnit.Case

  setup_all do
    Stripe.Accounts.delete_all

    new_account = [
      email: "test@example.com",
      managed: true,
      tos_acceptance: [
        date: :os.system_time(:seconds),
        ip: "127.0.0.1"
      ],
      legal_entity: [
        type: "individual",
        address: [
          city: "Los Angeles",
          country: "US",
          line1: "1st Ave",
          postal_code: "910000",
          state: "CA"
        ],
        dob: [
          day: 1,
          month: 1,
          year: 1991
        ],
        first_name: "John",
        last_name: "Doe"
      ],
      external_account: [
        object: "bank_account",
        country: "US",
        currency: "usd",
        routing_number: "110000000",
        account_number: "000123456789"
      ]
    ]

    account = case Stripe.Accounts.create new_account do
      {:ok, account} -> account
      {:error, err} -> flunk err
    end

    stripe_account = account.id
    Stripe.AccountCustomers.delete_all(stripe_account)

    new_customer = [
      email: "test@test.com",
      description: "An Elixir Test Account",
    ]

    case Stripe.AccountCustomers.create stripe_account, new_customer do
      {:ok, customer} ->
        on_exit fn ->
          Stripe.Accounts.delete account.id
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
