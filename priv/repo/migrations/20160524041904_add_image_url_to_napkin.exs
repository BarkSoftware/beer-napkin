defmodule BeerNapkin.Repo.Migrations.AddImageUrlToNapkin do
  use Ecto.Migration

  def change do
    alter table(:napkins) do
      add :image_url, :string
    end
  end
end
