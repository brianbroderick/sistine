defmodule SistineWeb.PaintingController do
  use SistineWeb, :controller

  alias Sistine.Art
  alias Sistine.Art.Painting

  def index(conn, _params) do
    paintings = Art.list_paintings()
    render(conn, "index.html", paintings: paintings)
  end

  def new(conn, _params) do
    changeset = Art.change_painting(%Painting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"painting" => painting_params}) do
    case Art.create_painting(painting_params) do
      {:ok, painting} ->
        conn
        |> put_flash(:info, "Painting created successfully.")
        |> redirect(to: Routes.painting_path(conn, :show, painting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    painting = Art.get_painting!(id)
    render(conn, "show.html", painting: painting)
  end

  def edit(conn, %{"id" => id}) do
    painting = Art.get_painting!(id)
    changeset = Art.change_painting(painting)
    render(conn, "edit.html", painting: painting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "painting" => painting_params}) do
    painting = Art.get_painting!(id)

    case Art.update_painting(painting, painting_params) do
      {:ok, painting} ->
        conn
        |> put_flash(:info, "Painting updated successfully.")
        |> redirect(to: Routes.painting_path(conn, :show, painting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", painting: painting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    painting = Art.get_painting!(id)
    {:ok, _painting} = Art.delete_painting(painting)

    conn
    |> put_flash(:info, "Painting deleted successfully.")
    |> redirect(to: Routes.painting_path(conn, :index))
  end
end
