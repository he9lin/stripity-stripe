defmodule Stripe.ManagedAccount.Customers do
  @endpoint "customers"

  def create(nil, _), do: {:error, "A connected account id is missing" }
  def create(stripe_account, params) do
    headers = HashDict.new |> Dict.put("Stripe-Account", stripe_account)

    Stripe.make_request(:post, @endpoint, params, headers)
      |> Stripe.Util.handle_stripe_response
  end

  def delete(nil, _), do: {:error, "A connected account id is missing" }
  def delete(stripe_account, id) do
    headers = HashDict.new |> Dict.put("Stripe-Account", stripe_account)

    Stripe.make_request(:delete, "#{@endpoint}/#{id}", [], headers)
      |> Stripe.Util.handle_stripe_response
  end

  def delete_all(nil), do: {:error, "A connected account id is missing" }
  def delete_all(stripe_account) do
    case all(stripe_account) do
      {:ok, customers} ->
        Enum.each customers, fn c -> delete(stripe_account, c["id"]) end
      {:error, err} -> raise err
    end
  end

  @max_fetch_size 100
  def all(stripe_account, accum \\ [], startingAfter \\ "") do
    headers = HashDict.new |> Dict.put("Stripe-Account", stripe_account)

    case list_raw("#{@endpoint}", @max_fetch_size, startingAfter, headers) do
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

  defp list_raw(endpoint, limit \\ 10, starting_after \\ "", headers \\ []) do
    list_raw endpoint, Stripe.config_or_env_key, limit, starting_after, headers
  end

  defp list_raw(endpoint, key, limit, starting_after, headers)  do
    q = "#{endpoint}?limit=#{limit}"

    if  String.length(starting_after) > 0 do
        q = q <> "&starting_after=#{starting_after}"
    end

    Stripe.make_request_with_key(:get, q, key, [], headers)
    |> Stripe.Util.handle_stripe_full_response
  end
end

