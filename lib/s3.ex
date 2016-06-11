defmodule BeerNapkin.S3 do
  use Timex
  use ExAws.S3.Client, otp_app: :beer_napkin

  def save_upload(plug_file) do
    {:ok, data} = File.read(plug_file.path)
    {:ok, date_key} = Date.today |> Timex.format("%Y/%m/%d", :strftime)
    file_extension = String.split(plug_file.filename, ".") |> List.last
    filename = "#{SecureRandom.uuid}.#{file_extension}"
    object_key = "uploads/#{date_key}/#{filename}"
    put_object!("beer-napkin", object_key, data, acl: :public_read)
    "https://s3.amazonaws.com/beer-napkin/#{object_key}"
  end

  def save_file(filename, data) do
    {:ok, date_key} = Date.today |> Timex.format("%Y/%m/%d", :strftime)
    object_key = "napkins/#{date_key}/#{filename}"
    put_object!("beer-napkin", object_key, data, acl: :public_read, content_type: "image/png")
    "https://s3.amazonaws.com/beer-napkin/#{object_key}"
  end
end
