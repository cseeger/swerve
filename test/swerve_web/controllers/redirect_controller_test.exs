defmodule SwerveWeb.RedirectControllerTest do
  use SwerveWeb.ConnCase

  alias Swerve.Links

  @create_attrs %{url: "http://www.shopno3.com"}

  def link_fixture() do
    {:ok, link} = Links.create_link(@create_attrs)
    link
  end

  describe "show" do
    test "with valid base62_url redirects to Link.url", %{conn: conn} do
      link = link_fixture()
      conn = get(conn, Routes.redirect_path(conn, :show, link.base62_url))
      assert redirected_to(conn) =~ link.url
    end

    test "with invalid base62_url redirects to app", %{conn: conn} do
      conn = get(conn, Routes.redirect_path(conn, :show, "asdf"))
      assert redirected_to(conn) =~ Routes.link_index_path(conn, :index)
    end
  end
end
