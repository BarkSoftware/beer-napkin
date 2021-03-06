defmodule BeerNapkin.NapkinController do
  use BeerNapkin.Web, :controller
  plug :authenticate
  alias BeerNapkin.Napkin

  def new(conn, _params) do
    changeset = Napkin.changeset(%Napkin{})
    render conn, "new.html", changeset: changeset, shareable: true
  end

  def create(conn, %{"napkin" => napkin_params, "napkin_image" => image}) do
    token = SecureRandom.urlsafe_base64
    image_key = save_image(image, token)
    user_napkin_params = Map.merge(napkin_params, %{
      "user_id" => conn.assigns.current_user.id,
      "image_url" => "#{s3_host}/#{bucket}/#{image_key}",
      "image_key" => image_key
    })

    changeset = Napkin.changeset(%Napkin{}, user_napkin_params)
    case Repo.insert(changeset) do
      {:ok, napkin} ->
        share(conn, napkin, user_napkin_params)
        conn
        |> put_flash(:info, "Napkin saved successfully.")
        |> redirect(to: napkin_path(conn, :edit, napkin))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    case load_napkin(conn, id) do
      {:ok, napkin} ->
        changeset = Napkin.changeset(napkin)
        render(conn, "edit.html", napkin: napkin, changeset: changeset, shareable: shareable?(napkin))
      {:unauthorized, msg} -> unauthorized(conn, msg)
    end
  end

  def update(conn, %{"id" => id, "napkin" => napkin_params, "napkin_image" => image}) do
    case load_napkin(conn, id) do
      {:ok, napkin} ->
        update_image(napkin, image)
        update_params = Map.take(napkin_params, [
          "json", "repository_full_name", "issue_title", "issue_description"
        ])
        changeset = Napkin.changeset(napkin, update_params)
        case Repo.update(changeset) do
          {:ok, napkin} ->
            share(conn, napkin, napkin_params)
            conn
            |> put_flash(:info, "Napkin saved successfully.")
            |> redirect(to: napkin_path(conn, :edit, napkin))
          {:error, changeset} ->
            render(conn, "edit.html", changeset: changeset)
        end
      {:unauthorized, msg} -> unauthorized(conn, msg)
    end

  end

  defp load_napkin(conn, id) do
    napkin = Repo.get!(Napkin, id) |> Repo.preload(:user)
    NapkinAccess.can_access?(conn.assigns.current_user, napkin)
  end

  defp unauthorized(conn, msg) do
    conn
      |> put_flash(:error, msg)
      |> redirect(to: page_path(conn, :index))
      |> halt()
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
    BeerNapkin.S3.save_png("#{token}.png", image_data)
  end

  defp update_image(napkin, base64_image) do
    normalized = base64_image |> String.split(",") |> List.last
    {:ok, image_data} = Base.decode64(normalized)
    BeerNapkin.S3.update_png(napkin.image_key, image_data)
  end

  defp share(conn, napkin, napkin_params) do
    case {napkin_params["issue_title"] || "", napkin.issue_url || ""} do
      {"", ""} -> napkin_params
      {_title, ""} ->
        token = conn.assigns.current_user.token
        issue_url = ShareAsGithubIssue.share(
          token,
          napkin.repository_full_name,
          napkin.image_url,
          napkin_url(BeerNapkin.Endpoint, :edit, napkin.id),
          napkin.issue_title,
          napkin.issue_description || ""
        )
        changeset = Napkin.changeset(napkin, %{"issue_url" => issue_url})
        Repo.update(changeset)
        napkin_params
      {_title, _url} -> napkin_params
    end
  end

  defp bucket do
    Application.get_env(:beer_napkin, :s3_bucket)
  end

  defp s3_host do
    Application.get_env(:beer_napkin, :s3_host)
  end

  defp shareable?(napkin) do
    String.length(napkin.issue_url || "") == 0
  end
end
