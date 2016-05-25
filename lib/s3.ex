defmodule BeerNapkin.S3 do
  use Timex
  use ExAws.S3.Client, otp_app: :beer_napkin

  def save_file(filename, data) do
    {:ok, date_key} = Date.today |> Timex.format("%Y/%m/%d", :strftime)
    object_key = "napkins/#{date_key}/#{filename}"
    put_object!("beer-napkin", object_key, data)
    "https://s3.amazonaws.com/beer-napkin/#{object_key}"
  end
end
