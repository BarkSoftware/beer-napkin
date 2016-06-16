require IEx
defmodule BeerNapkin.S3 do
  use Timex
  use ExAws.S3.Client, otp_app: :beer_napkin
  @bucket Application.get_env(:beer_napkin, :s3_bucket)
  # We don't want github to cache the png images
  @png_options [content_type: "image/png", cache_control: "no-cache", acl: :public_read]

  def save_upload(plug_file) do
    {:ok, data} = File.read(plug_file.path)
    {:ok, date_key} = Date.today |> Timex.format("%Y/%m/%d", :strftime)
    file_extension = String.split(plug_file.filename, ".") |> List.last
    filename = "#{SecureRandom.uuid}.#{file_extension}"
    object_key = "uploads/#{date_key}/#{filename}"
    put_object!("beer-napkin", object_key, data, acl: :public_read)
    "https://s3.amazonaws.com/beer-napkin/#{object_key}"
  end

  def save_png(filename, data) do
    {:ok, date_key} = Date.today |> Timex.format("%Y/%m/%d", :strftime)
    object_key = "napkins/#{date_key}/#{filename}"
    put_object!("beer-napkin", object_key, data, @png_options)
    object_key
  end

  def update_png(key, data) do
    put_object!(@bucket, key, data, @png_options)
    key
  end
end
