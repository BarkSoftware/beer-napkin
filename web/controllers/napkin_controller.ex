defmodule BeerNapkin.NapkinController do
  use BeerNapkin.Web, :controller
  plug :authenticate
  alias BeerNapkin.Napkin

  def new(conn, _params) do
    changeset = Napkin.changeset(%Napkin{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"napkin" => napkin_params, "napkin_image" => image}) do
    token = SecureRandom.urlsafe_base64
    user_napkin_params = Map.merge(napkin_params, %{
      "user_id" => conn.assigns.current_user.id,
      "token" => token,
      "image_url" => save_image(image, token)
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
    napkin = load_napkin(conn, id)
    changeset = Napkin.changeset(napkin)
    render(conn, "edit.html", napkin: napkin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "napkin" => napkin_params, "napkin_image" => image}) do
    napkin = load_napkin(conn, id)
    image_url = save_image(image, napkin.token)
    update_params = Map.take(napkin_params, ["json"]) |> Map.merge(%{"image_url" => image_url})
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

  defp load_napkin(conn, id) do
    napkin = Repo.get!(Napkin, id) |> Repo.preload(:user)
    access_to_napkin(conn, napkin)
    napkin
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
      |> redirect(to: "/auth/github")
      |> halt()
    end
  end

  defp save_image(base64_image, token) do
    normalized = base64_image |> String.split(",") |> List.last
    {:ok, image_data} = Base.decode64(normalized)
    file_url = BeerNapkin.S3.save_file("#{token}.png", image_data)
  end
end
