defmodule BeerNapkin.Repo.Migrations.AddTokenToUploads do
  use Ecto.Migration

  def change do
    alter table(:uploads) do
      add :token, :string
    end
  end
end
