defmodule Swerve.LinksTest do
  use Swerve.DataCase

  alias Swerve.Links

  describe "links" do
    alias Swerve.Links.Link

    @valid_attrs %{url: "http://www.example.com"}
    @update_attrs %{url: "http://updated.example.com"}
    @invalid_attrs %{url: "invalid"}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Links.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      [%Link{url: url}] = Links.list_links()
      assert url == link.url
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Links.create_link(@valid_attrs)
      assert link.url == "http://www.example.com"
      assert link.base62_url != nil
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, %Link{} = link} = Links.update_link(link, @update_attrs)
      assert link.url == "http://updated.example.com"
    end

    test "update_link/2 with valid data also updates the base62_url" do
      link = link_fixture()
      assert {:ok, %Link{} = link} = Links.update_link(link, @update_attrs)
      assert link.base62_url != nil
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link.url == Links.get_link!(link.id).url
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "get_redirect/1 returns the link with given base62_url" do
      link = link_fixture()
      assert Links.get_redirect(link.base62_url) == link
    end
  end
end
