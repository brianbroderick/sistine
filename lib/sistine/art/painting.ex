defmodule Sistine.Art.Painting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "paintings" do
    field :artist, :string
    field :name, :string
    field :rating, :integer
    field :last_modified_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(painting, attrs) do
    painting
    |> cast(attrs, [:name, :artist])
    |> validate_required([:name, :artist])
  end
end
