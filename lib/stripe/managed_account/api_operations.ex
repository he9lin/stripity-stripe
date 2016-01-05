defmodule Stripe.ManagedAccount.ApiOperations do
  import Stripe.ManagedAccount, only: [make_request: 3, make_request: 4, list_raw: 4]

  def create(_, nil, _), do: {:error, "account id is missing"}
  def create(endpoint, stripe_account, params) do
    make_request(stripe_account, :post, endpoint, params)
      |> Stripe.Util.handle_stripe_response
  end

  def delete(_, nil, _), do: {:error, "account id is missing"}
  def delete(endpoint, stripe_account, id) do
    make_request(stripe_account, :delete, "#{endpoint}/#{id}")
      |> Stripe.Util.handle_stripe_response
  end

  def change(_, nil, _, _), do: {:error, "account id is missing"}
  def change(endpoint, stripe_account, id, params) do
    make_request(stripe_account, :post, "#{endpoint}/#{id}", params)
      |> Stripe.Util.handle_stripe_response
  end

  def delete_all(_, nil), do: {:error, "account id is missing"}
  def delete_all(endpoint, stripe_account) do
    case all(endpoint, stripe_account) do
      {:ok, entity} ->
        Enum.each entity, fn c -> delete(endpoint, stripe_account, c["id"]) end
      {:error, err} -> raise err
    end
  end

  @max_fetch_size 100
  def all(endpoint, stripe_account, accum \\ [], startingAfter \\ "") do
    case list_raw(stripe_account, endpoint, @max_fetch_size, startingAfter) do
      {:ok, resp}  ->
        case resp[:has_more] do
          true ->
            last_sub = List.last( resp[:data] )
            all( resp[:data] ++ accum, last_sub["id"] )
          false ->
            result = resp[:data] ++ accum
            {:ok, result}
        end
      {:error, err} -> raise err
    end
  end
end
