defmodule SwerveWeb.PageController do
  use SwerveWeb, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/links")
      |> halt()
    else
      render(conn, "index.html")
    end
  end
end
