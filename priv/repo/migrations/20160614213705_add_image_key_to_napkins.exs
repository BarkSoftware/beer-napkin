defmodule BeerNapkin.Repo.Migrations.AddImageKeyToNapkins do
  use Ecto.Migration

  def change do
    alter table(:napkins) do
      add :image_key, :string
    end
  end
end
