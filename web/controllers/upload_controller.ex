defmodule BeerNapkin.UploadController do
  use BeerNapkin.Web, :controller
  alias BeerNapkin.Upload
  plug :authenticate

  @byte_limit 2097152 # 2mb

  def show(conn, %{"id" => token}) do
    upload = Repo.get_by!(Upload, token: token)
    s3_response = HTTPoison.get! upload.url
    content_type = s3_response.headers |> Enum.find(fn(h) -> elem(h, 0) == "Content-Type" end) |> elem(1)
    put_resp_header(conn, "content-type", content_type)
    resp(conn, 200, s3_response.body)
  end

  def create(conn, %{"file"=> file}) do
    {:ok, data} = File.read(file.path)
    if byte_size(data) > @byte_limit do
      raise "File too large"
    else
      token = SecureRandom.urlsafe_base64
      url = BeerNapkin.S3.save_upload(file)
      upload_params = %{
        "token" => token,
        "url" => url,
      }

      changeset = Upload.changeset(%Upload{}, upload_params)
      case Repo.insert(changeset) do
        {:ok, _upload} ->
          json(conn, %{url: "/uploads/#{token}"})
      end
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
