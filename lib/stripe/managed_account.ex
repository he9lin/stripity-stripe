defmodule Stripe.ManagedAccount do
  def make_request(stripe_account, method, endpoint, body \\ []) do
    headers = HashDict.new |> Dict.put("Stripe-Account", stripe_account)
    Stripe.make_request(method, endpoint, body, headers)
  end

  def list_raw(stripe_account, endpoint, limit \\ 10, starting_after \\ "") do
    headers = HashDict.new |> Dict.put("Stripe-Account", stripe_account)
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
