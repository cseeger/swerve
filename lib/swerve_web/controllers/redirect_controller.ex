defmodule SwerveWeb.RedirectController do
  use SwerveWeb, :controller

  alias Swerve.Links
  alias Swerve.Links.Link

  def show(conn, %{"base62_url" => base62_url}) do
    case Links.get_redirect(base62_url) do
      %Link{url: url} ->
        redirect(conn, external: url) |> halt()

      nil ->
        redirect(
          conn,
          to: SwerveWeb.Router.Helpers.link_index_path(conn, :index)
        )
        |> halt()
    end
  end
end
