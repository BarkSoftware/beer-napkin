defmodule BeerNapkin.AuthController do
  use BeerNapkin.Web, :controller
  alias BeerNapkin.User
  alias BeerNapkin.Repo
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case user_from_auth(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user.id)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp user_from_auth auth do
    image = auth.extra.raw_info.user["avatar_url"]
    token = auth.credentials.token
    email = auth.info.email
    params = %{username: auth.info.nickname}
    if email do
      params = Map.merge(params, %{email: email})
    end

    user = Repo.get_by(User, params)
    if is_nil(user) do
      all_params = Map.put_new(params, :token, token)
      all_params = Map.put_new(all_params, :image, image)
      changeset = User.changeset(%User{}, all_params)
      Repo.insert(changeset)
    else
      update_params = %{token: token, image: image, email: email}
      changeset = User.changeset(user, update_params)
      Repo.update(changeset)
    end
  end
end
