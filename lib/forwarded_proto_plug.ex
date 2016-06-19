defmodule BeerNapkin.ForwardedProtoPlug do
  @moduledoc """
  Unfortunately it seems Cloudflare is misreporting the x-forwarded-proto header
  as http sometimes when it's actually https. This is messing up Github callbacks
  so we're overriding it here for Github authentication.

  See: https://github.com/ueberauth/ueberauth/blob/dd7631ea3967932bdf0d70ceb24287a77c7da798/lib/ueberauth/strategies/helpers.ex#L155
  """

  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    if enabled? do
      new_headers = conn.req_headers ++ [{"x-forwarded-proto", "https"}]
      conn |> Map.put(:req_headers, new_headers)
    else
      conn
    end
  end

  defp enabled? do
    Application.get_env(:beer_napkin, :force_ssl_forwarded_proto)
  end
end
