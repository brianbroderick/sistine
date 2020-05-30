defmodule Sistine.Art do
  @moduledoc """
  The Art context.
  """

  import Ecto.Query, warn: false
  alias Sistine.Repo

  alias Sistine.Art.Painting

  @doc """
  Returns the list of paintings.

  ## Examples

      iex> list_paintings()
      [%Painting{}, ...]

  """
  def list_paintings do
    Repo.all(Painting)
  end

  @doc """
  Gets a single painting.

  Raises `Ecto.NoResultsError` if the Painting does not exist.

  ## Examples

      iex> get_painting!(123)
      %Painting{}

      iex> get_painting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_painting!(id), do: Repo.get!(Painting, id)

  @doc """
  Creates a painting.

  ## Examples

      iex> create_painting(%{field: value})
      {:ok, %Painting{}}

      iex> create_painting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_painting(attrs \\ %{}) do
    %Painting{}
    |> Painting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a painting.

  ## Examples

      iex> update_painting(painting, %{field: new_value})
      {:ok, %Painting{}}

      iex> update_painting(painting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_painting(%Painting{} = painting, attrs) do
    painting
    |> Painting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a painting.

  ## Examples

      iex> delete_painting(painting)
      {:ok, %Painting{}}

      iex> delete_painting(painting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_painting(%Painting{} = painting) do
    Repo.delete(painting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking painting changes.

  ## Examples

      iex> change_painting(painting)
      %Ecto.Changeset{data: %Painting{}}

  """
  def change_painting(%Painting{} = painting, attrs \\ %{}) do
    Painting.changeset(painting, attrs)
  end
end
