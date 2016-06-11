defmodule BeerNapkin.Repo.Migrations.AddGithubFieldsToNapkins do
  use Ecto.Migration

  def change do
    alter table(:napkins) do
      add :repository_full_name, :string
      add :issue_title, :string
      add :issue_description, :text
      add :issue_url, :string
    end
  end
end
