defmodule BeerNapkin.UserContext do
  import Plug.Conn
  alias BeerNapkin.User

  def init(default), do: default

  def call(conn, _) do
    assign(conn, :current_user, %User{username: "testuser"})
  end
end
