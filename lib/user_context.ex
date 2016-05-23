defmodule BeerNapkin.UserContext do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :current_user)
    user = user_id && repo.get(BeerNapkin.User, user_id)
    assign(conn, :current_user, user)
  end
end
