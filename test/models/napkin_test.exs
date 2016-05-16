defmodule BeerNapkin.NapkinTest do
  use BeerNapkin.ModelCase

  alias BeerNapkin.Napkin

  @valid_attrs %{json: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Napkin.changeset(%Napkin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Napkin.changeset(%Napkin{}, @invalid_attrs)
    refute changeset.valid?
  end
end
