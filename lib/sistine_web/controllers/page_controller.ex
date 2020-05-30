defmodule SistineWeb.PageController do
  use SistineWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
