defmodule SwerveWeb.LinkLiveTest do
  use SwerveWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Swerve.Links

  @create_attrs %{url: "http://www.example.com"}
  @update_attrs %{url: "http://updated.example.com"}
  @invalid_attrs %{url: nil}

  setup :register_and_log_in_user

  defp fixture(:link) do
    {:ok, link} = Links.create_link(@create_attrs)
    link
  end

  defp create_link(_) do
    link = fixture(:link)
    %{link: link}
  end

  describe "Index" do
    setup [:create_link]

    test "lists all links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, Routes.link_index_path(conn, :index))

      assert html =~ "Listing Links"
      assert html =~ link.url
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.link_index_path(conn, :index))

      assert index_live |> element("a", "New Link") |> render_click() =~
               "New Link"

      assert_patch(index_live, Routes.link_index_path(conn, :new))

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#link-form", link: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.link_index_path(conn, :index))

      assert html =~ "Link created successfully"
      assert html =~ "http://www.example.com"
    end

    test "updates link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, Routes.link_index_path(conn, :index))

      assert index_live |> element("#link-#{link.id} a", "Edit") |> render_click() =~
               "Edit Link"

      assert_patch(index_live, Routes.link_index_path(conn, :edit, link))

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#link-form", link: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.link_index_path(conn, :index))

      assert html =~ "Link updated successfully"
      assert html =~ "http://updated.example.com"
    end

    test "deletes link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, Routes.link_index_path(conn, :index))

      assert index_live |> element("#link-#{link.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#link-#{link.id}")
    end
  end

  describe "Show" do
    setup [:create_link]

    test "displays link", %{conn: conn, link: link} do
      {:ok, _show_live, html} = live(conn, Routes.link_show_path(conn, :show, link))

      assert html =~ "Show Link"
      assert html =~ link.url
    end

    test "updates link within modal", %{conn: conn, link: link} do
      {:ok, show_live, _html} = live(conn, Routes.link_show_path(conn, :show, link))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Link"

      assert_patch(show_live, Routes.link_show_path(conn, :edit, link))

      assert show_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#link-form", link: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.link_show_path(conn, :show, link))

      assert html =~ "Link updated successfully"
      assert html =~ "http://updated.example.com"
    end
  end
end
