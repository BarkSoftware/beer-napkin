defmodule BeerNapkin.NapkinController do
  use BeerNapkin.Web, :controller
  plug :authenticate
  alias BeerNapkin.Napkin

  def new(conn, _params) do
    changeset = Napkin.changeset(%Napkin{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"napkin" => napkin_params}) do
    user_napkin_params = Map.merge(napkin_params, %{
      "user_id" => conn.assigns.current_user.id,
      "token" => SecureRandom.urlsafe_base64
    })

    changeset = Napkin.changeset(%Napkin{}, user_napkin_params)
    case Repo.insert(changeset) do
      {:ok, napkin} ->
        conn
        |> put_flash(:info, "Napkin saved successfully.")
        |> redirect(to: napkin_path(conn, :edit, napkin))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    napkin = load_napkin(id)
    changeset = Napkin.changeset(napkin)
    case access_to_napkin(conn, napkin) do
      %Plug.Conn{halted: true} = conn ->
        conn
      conn ->
        render(conn, "edit.html", napkin: napkin, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "napkin" => napkin_params}) do
    napkin = Repo.get!(Napkin, id)
    update_params = Map.take(napkin_params, ["json"])
    changeset = Napkin.changeset(napkin, update_params)
    case Repo.update(changeset) do
      {:ok, napkin} ->
        conn
        |> put_flash(:info, "Napkin saved successfully.")
        |> redirect(to: napkin_path(conn, :edit, napkin))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp load_napkin(id) do
    napkin = Repo.get!(Napkin, id) |> Repo.preload(:user)
  end

  defp access_to_napkin(conn, napkin) do
    if conn.assigns.current_user.id == napkin.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You do not have access to this napkin.")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access Beer Napkin.") |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
