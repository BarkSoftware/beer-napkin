defmodule BeerNapkin.UserContext do
  import Plug.Conn

  def init(default), do: default

  def call(conn, assigns) do
    assign(conn, :current_user, current_user(conn))
  end

  defp current_user(conn) do
    get_session(conn, :current_user)
  end
end
