defmodule BeerNapkin.Repo.Migrations.CreateNapkin do
  use Ecto.Migration

  def change do
    create table(:napkins) do
      add :json, :text
      add :token, :string, size: 36
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:napkins, [:user_id])

  end
end
