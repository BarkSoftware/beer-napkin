defmodule BeerNapkin.Napkin do
  use BeerNapkin.Web, :model

  schema "napkins" do
    field :json, :string
    field :token, :string
    field :image_url, :string
    field :issue_title, :string
    field :issue_description, :string
    field :repository_full_name, :string
    field :issue_url, :string
    belongs_to :user, BeerNapkin.User

    timestamps
  end

  @required_fields ~w(json token user_id image_url)
  @optional_fields ~w(issue_title issue_description repository_full_name issue_url)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
