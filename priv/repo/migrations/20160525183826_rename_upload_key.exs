defmodule BeerNapkin.Repo.Migrations.RenameUploadKey do
  use Ecto.Migration

  def change do
    rename table(:uploads), :key, to: :url
  end
end
