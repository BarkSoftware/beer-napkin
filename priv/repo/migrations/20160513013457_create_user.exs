defmodule BeerNapkin.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :token, :string

      timestamps
    end

  end
end
