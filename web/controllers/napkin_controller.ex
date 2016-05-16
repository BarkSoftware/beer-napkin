defmodule BeerNapkin.NapkinController do
  use BeerNapkin.Web, :controller
  alias BeerNapkin.Napkin

  def new(conn, _params) do
    changeset = Napkin.changeset(%Napkin{})
    render conn, "new.html", changeset: changeset
  end
end
