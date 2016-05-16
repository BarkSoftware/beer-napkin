defmodule BeerNapkin.Napkin do
  use BeerNapkin.Web, :model

  schema "napkins" do
    field :json, :string
    field :token, :string
    belongs_to :user, BeerNapkin.User

    timestamps
  end

  @required_fields ~w(json token)
  @optional_fields ~w()

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
