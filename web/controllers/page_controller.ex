require IEx
defmodule BeerNapkin.PageController do
  use BeerNapkin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def ping(conn, _params) do
    render conn, "ping.html", req_headers: conn.req_headers
  end
end
