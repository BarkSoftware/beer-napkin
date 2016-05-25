defmodule BeerNapkin.Repo.Migrations.CreateUpload do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :key, :string

      timestamps
    end

  end
end
