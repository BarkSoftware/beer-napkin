defmodule BeerNapkin.Napkin do
  use BeerNapkin.Web, :model

  schema "napkins" do
    field :json, :string
    field :token, :string
    field :image_url, :string
    field :image_key, :string
    field :issue_title, :string
    field :issue_description, :string
    field :repository_full_name, :string
    field :issue_url, :string
    belongs_to :user, BeerNapkin.User

    timestamps
  end

  @required_fields ~w(json token user_id image_url image_key)
  @optional_fields ~w(issue_title issue_description repository_full_name issue_url)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_issue_fields
  end

  defp validate_issue_fields(changeset) do
    repo_name = get_field(changeset, :repository_full_name)
    title = get_field(changeset, :issue_title)
    case {String.length(repo_name || "") > 0, String.length(title || "") > 0} do
      {true, false} -> add_error(changeset, :issue_title, "Issue title is required.")
      {_, _} -> changeset
    end
  end
end
