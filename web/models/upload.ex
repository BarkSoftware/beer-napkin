defmodule BeerNapkin.Upload do
  use BeerNapkin.Web, :model

  schema "uploads" do
    field :url, :string
    field :token, :string

    timestamps
  end

  @required_fields ~w(url token)
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
