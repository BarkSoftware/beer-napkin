defmodule BeerNapkin.PageController do
  use BeerNapkin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
